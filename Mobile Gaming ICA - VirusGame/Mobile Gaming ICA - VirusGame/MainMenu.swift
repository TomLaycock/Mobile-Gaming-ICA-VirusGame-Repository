//
//  MainMenu.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by LAYCOCK, TOM (Student) on 29/11/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class Button: SKSpriteNode {
    
}

class MainMenu: SKScene {
    
    let mGameTitle = "MenuTextures/GameTitle"
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    
    override func didMove(to view: SKView) {
        
        print("Test")
        
        let MenuTitle = SKSpriteNode(imageNamed: mGameTitle)
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
        MenuTitle.position = CGPoint(x: frame.midX, y: frame.midY * 2 - MenuTitle.frame.height)
        
        addChild(MenuTitle)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
