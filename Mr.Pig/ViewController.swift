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
 
    var scnView:SCNView!
    var gameScene:SCNScene!
    var splashScene:SCNScene!
    
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
        
    }
    
    func setupActions() {
        
    }
    
    func setupTraffic() {
        
    }
    
    func setupGestures() {
        
    }
    
    func setupSounds() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    


}

