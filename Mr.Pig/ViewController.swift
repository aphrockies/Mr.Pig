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
        
    }
    
    func setupActions() {
        
        driveLeftAction = SCNAction.repeatForever(SCNAction.moveBy(x: -2.0, y: 0, z: 0, duration: 1.0))
        driveRightAction = SCNAction.repeatForever(SCNAction.moveBy(x: 2.0, y: 0, z: 0, duration: 1.0))
         
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

