//
//  GameViewController.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by LAYCOCK, TOM (Student) on 05/11/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var mGameScene : GameScene!
    var mMainMenuScene : MainMenu!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !defaults.bool(forKey: "FirstTimeLoad")
        {
            defaults.set(true, forKey: "FirstTimeLoad")
            defaults.set(true, forKey: "AudioToggleValue")
            defaults.set(false, forKey: "AltToggleValue")
        }
        
        if let view = self.view as! SKView? {
            
            if let scene = MainMenu(fileNamed: "MainMenu")
            {
                mMainMenuScene = scene
                scene.scaleMode = .resizeFill
            }
            
            if let scene = GameScene(fileNamed: "GameScene")
            {
                mGameScene = scene
                scene.scaleMode = .resizeFill
            }
            
            mMainMenuScene.mGameScene = mGameScene
            mGameScene.mMainMenuScene = mMainMenuScene
            
            view.presentScene(mMainMenuScene, transition: .fade(withDuration: 0.5))
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if let skView = view as? SKView, let scene = skView.scene as? GameScene {
                scene.ShakeDevice()
            }
        }
    }
}
