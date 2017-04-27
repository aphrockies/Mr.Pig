//
//  ViewController.swift
//  Mr.Pig
//
//  Created by Allan Hull on 2/26/17.
//  Copyright © 2017 com.APHrockies2016.mobi. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {

    // scenes
    var scnView:SCNView!
    var gameScene:SCNScene!
    var splashScene:SCNScene!
    
    // nodes
    var pigNode: SCNNode!
    var cameraNode: SCNNode!
    var cameraFollowNode: SCNNode!
    var lightFollowNode: SCNNode!
    var trafficNode: SCNNode!
    
    // actions
    var driveLeftAction: SCNAction!
    var driveRightAction: SCNAction!
    var jumpLeftAction: SCNAction!
    var jumpRightAction: SCNAction!
    var jumpForwardAction: SCNAction!
    var jumpBackwardAction: SCNAction!
    
    var triggerGameOver: SCNAction!
    
    // collision 
    var collisionNode: SCNNode!
    var frontCollisionNode: SCNNode!
    var backCollisionNode: SCNNode!
    var leftCollisionNode: SCNNode!
    var rightCollisionNode: SCNNode!
    
    // physics
    let BitMaskPig = 1
    let BitMaskVehichle = 2
    let BitMaskObstacle = 4
    let BitMaskFront = 8
    let BitMaskBack = 16
    let BitMaskLeft = 32
    let BitMaskRight = 64
    let BitMaskCoin = 128
    let BitMaskHouse = 256
    
    
    
    let game = GameHelper.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Games
        setupScenes()
        setupNodes()
        setupActions()
        setupTraffic()
        setupGestures()
        setupSounds()
        
        
    }

    func setupScenes() {
        
        print("setupScenes")
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        
        // setup scenes
        gameScene = SCNScene(named: "/MrPig.scnassets/GameScene.scn")
        splashScene = SCNScene(named: "/MrPig.scnassets/SplashScene.scn")
        
        scnView.scene = splashScene
        
        scnView.delegate = self
        
    }
    
    func setupNodes() {
        
        // Mr. Pig
        pigNode = gameScene.rootNode.childNode(withName: "MrPig",recursively: true)!
        
        // Camera
        cameraNode = gameScene.rootNode.childNode(withName: "camera", recursively: true)!
        cameraNode.addChildNode(game.hudNode)
        
        cameraNode = gameScene.rootNode.childNode(withName: "FollowCamera",recursively: true)!
        
        // Lights
        lightFollowNode = gameScene.rootNode.childNode(withName: "FollowLight", recursively: true)!
        
        // Traffic
        trafficNode = gameScene.rootNode.childNode(withName: "Traffic", recursively: true)!
        
        // collisions
        collisionNode = gameScene.rootNode.childNode(withName: "Collision", recursively: true)!
        frontCollisionNode = gameScene.rootNode.childNode(withName: "Front", recursively: true)!
        backCollisionNode = gameScene.rootNode.childNode(withName: "Back", recursively: true)!
        leftCollisionNode = gameScene.rootNode.childNode(withName: "Left", recursively: true)!
        rightCollisionNode = gameScene.rootNode.childNode(withName: "Right", recursively: true)!
        
        // set contact bit masks
        pigNode.physicsBody?.contactTestBitMask = BitMaskVehichle | BitMaskCoin | BitMaskHouse
        frontCollisionNode.physicsBody?.contactTestBitMask = BitMaskObstacle
        backCollisionNode.physicsBody?.contactTestBitMask = BitMaskObstacle
        leftCollisionNode.physicsBody?.contactTestBitMask = BitMaskObstacle
        rightCollisionNode.physicsBody?.contactTestBitMask = BitMaskObstacle
        
        
    }
    
    func setupActions() {
        
        driveLeftAction = SCNAction.repeatForever(SCNAction.moveBy(x: -2.0, y: 0, z: 0, duration: 1.0))
        driveRightAction = SCNAction.repeatForever(SCNAction.moveBy(x: 2.0, y: 0, z: 0, duration: 1.0))
        
        let duration = 0.2
        
        let bounceUpAction =  SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration: duration * 0.5)
        let bounceDownAction = SCNAction.moveBy(x: 0, y:-1.0, z: 0, duration: duration * 0.5)
        
        bounceUpAction.timingMode = .easeOut
        bounceDownAction.timingMode = .easeIn
        
        let bounceAction = SCNAction.sequence([bounceUpAction,bounceDownAction])
        
        let moveLeftAction = SCNAction.moveBy(x: -1.0, y: 0, z: 0, duration: duration)
        let moveRightAction = SCNAction.moveBy(x: 1.0, y: 0, z: 0, duration: duration)
        let moveForwardAction = SCNAction.moveBy(x: 0, y: 0, z: -1.0, duration: duration)
        let moveBackwardAction = SCNAction.moveBy(x: 0, y: 0, z: 1.0, duration: duration)
        
        let turnLeftAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle: -90), z: 0, duration: duration, usesShortestUnitArc: true)
        let turnRightAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle: 90), z: 0, duration: duration, usesShortestUnitArc: true)
        let turnForwardAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle: 180), z: 0, duration: duration, usesShortestUnitArc: true)
        let turnBackwardAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle: 0), z: 0, duration: duration, usesShortestUnitArc: true)
        
        jumpLeftAction = SCNAction.group([turnLeftAction, bounceAction, moveLeftAction])
        jumpRightAction = SCNAction.group([turnRightAction, bounceAction, moveRightAction])
        jumpForwardAction = SCNAction.group([turnForwardAction, bounceAction, moveForwardAction])
        jumpBackwardAction = SCNAction.group([turnBackwardAction, bounceAction, moveBackwardAction])
        
        let spinAround = SCNAction.rotateBy(x: 0, y: convertToRadians(angle: 720), z: 0, duration: 2.0)
        let riseUp = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 2.0)
        let fadeOut = SCNAction.fadeOpacity(to: 0, duration: 2.0)
        let goodByePig = SCNAction.group([spinAround, riseUp, fadeOut])
        
        let gameOver = SCNAction.run {  (node:SCNNode) -> Void in
            self.pigNode.position = SCNVector3(x:0, y:0, z:0)
            self.pigNode.opacity = 1.0
            self.startSplash()
        }
        
        triggerGameOver = SCNAction.sequence([goodByePig, gameOver])
        
         
    }
    
    func setupTraffic() {
        
        for node in trafficNode.childNodes {
            
            // 2 buses are slow, the rest are speed demons
            if (node.name?.contains("Bus"))! {
                driveLeftAction.speed = 1.0
                driveRightAction.speed = 1.0
            } else {
                driveLeftAction.speed = 2.0
                driveRightAction.speed = 2.0
            }
            
            // let vehicle drive towards it facing direction
            if node.eulerAngles.y > 0 {
                node.runAction(driveLeftAction)
            } else {
                node.runAction(driveRightAction)
            }
            
        }
        
    }
    
    func setupGestures() {
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(ViewController.handleGesture(sender:)))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(ViewController.handleGesture(sender:)))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)
        
        let swipeForward:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(ViewController.handleGesture(sender:)))
        swipeForward.direction = .up
        scnView.addGestureRecognizer(swipeForward)
        
        let swipeBackward:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(ViewController.handleGesture(sender:)))
        swipeBackward.direction = .down
        scnView.addGestureRecognizer(swipeBackward)
 
        
    }
    
    func setupSounds() {
        
    }
    
    func startGame() {
        splashScene.isPaused = true
        
        let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
 
        scnView.present(gameScene, with: transition, incomingPointOfView: nil, completionHandler:  {
            
            self.game.state = .Playing
            self.setupSounds()
            self.gameScene.isPaused = false
        })
        
    }
    
    func stopGame() {
        game.state = .GameOver
        game.reset()
        pigNode.runAction(triggerGameOver)
    }
    
    func startSplash() {
        
        gameScene.isPaused = true
        
        let transition = SKTransition.doorsOpenVertical(withDuration: 1.0 )
        scnView.present(gameScene, with: transition, incomingPointOfView: nil, completionHandler:  {
            
            self.game.state = .Playing
            self.setupSounds()
            self.gameScene.isPaused = false
        })
  
    }
    
    
    func handleGesture(sender:UISwipeGestureRecognizer) {
        
//        guard game.state = .Playing else {
//            return
//        }
        
//        stopGame()
//        return
        
        print("handleGesture")
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            pigNode.runAction(jumpForwardAction)
            print("jumpForward")
        case UISwipeGestureRecognizerDirection.down:
            pigNode.runAction(jumpBackwardAction)
            print("jumpBackward")
        case UISwipeGestureRecognizerDirection.left:
            if pigNode.position.x > -15 {
                pigNode.runAction(jumpLeftAction)
                print("jumpLeft")
            }
        case UISwipeGestureRecognizerDirection.right:
            if pigNode.position.x < 15 {
                pigNode.runAction(jumpRightAction)
                print("jumpRight")
            }
        default:
            break
            
        }
        
        
    }
    
    func updatePositions() {
        collisionNode.position = pigNode.presentation.position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.state == .TapToPlay {
            startGame()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        guard game.state == .Playing else {
            return
        }
        game.updateHUD()
        
        updatePositions()
        
    }
    
    
}

