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

class MainMenu: SKScene {
    
    var mGameScene : GameScene!
    
    let mGameTitle = "MenuTextures/GameTitle"
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    
    var mSceneLoadingComplete = false
    
    override func didMove(to view: SKView) {
        
        //if(mSceneLoadingComplete) { return }
        
        //mSceneLoadingComplete = true
        
        print("Loading Main Menu")
        
        let MenuTitle = SKSpriteNode(imageNamed: mGameTitle)
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
        MenuTitle.position = CGPoint(x: frame.midX, y: frame.midY * 2 - MenuTitle.frame.height)
        
        addChild(MenuTitle)
        
        var Offset = CGFloat(-1)
        
        for ButtonName in mButtons {
            let MenuButton = Button(imageNamed: "MenuButtons/" + ButtonName)
            MenuButton.name = ButtonName
            MenuButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
            MenuButton.position = CGPoint(x: frame.midX + (Offset * MenuButton.frame.width * 2), y: frame.midY)
            MenuButton.SetButtonPosition(to: MenuButton.position)
            
            Offset = Offset + CGFloat(1)
            
            addChild(MenuButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == mButtons[0]
            {
                removeAllChildren()
                
                mGameScene.scaleMode = .resizeFill
                view?.presentScene(mGameScene)
            }
            if touchedNode.name == mButtons[1]
            {
                
            }
            if touchedNode.name == mButtons[2]
            {
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
