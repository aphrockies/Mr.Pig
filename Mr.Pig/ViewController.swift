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
        
    }
    
    func setupActions() {
        
    }
    
    func setupTraffic() {
        
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

