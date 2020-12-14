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
    
    var mDeltaTime = Double(0)
    var mPrevTime = Double(0)
    
    let mGameTitle = "Assets/MenuTextures/GameTitle-TB"
    let mButtons = ["PlayButton-TB", "OptionsButton-TB"]
    
    let mOptionsMenu = MainOptionsMenu()
    let mInfoMenu = InfoMenu()
    let mSoundSystem = CustomSoundSystem()
    
    var mSceneLoadingComplete = false
    
    var mOptionsMenuActive = false
    
    //Background Cells
    var mViruses : [MainMenuVirus] = []
    
    //User Save Options
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {

        mOptionsMenuActive = false
        
        if !mSceneLoadingComplete
        {
            mOptionsMenu.SetupGameOptionsMenu(scene: self, audioOn: defaults.bool(forKey: "AudioToggleValue"), altOn: defaults.bool(forKey: "AltToggleValue"))
            mSoundSystem.SetupCustomSoundSystem()
            mInfoMenu.SetupInfoMenu(scene: self)
            
            for i in 1...8
            {
                let randomChoice = Int.random(in: 0...1)
                
                if randomChoice == 1 { continue }
                
                for j in 1...4
                {
                    let randomNum = Int.random(in: 0...2)
                    let newMainMenuVirus = MainMenuVirus(back: "Assets/Viruses/Virus-000" + String(randomNum) + "-SpikesOnly", front: "Assets/Viruses/Virus-000" + String(randomNum) + "-BodyOnly", speed: 100)
                    newMainMenuVirus.SpawnMainMenuVirus(at: CGPoint(x: ((frame.maxX / 8) * CGFloat(i)) - (frame.maxX / 20), y: (frame.maxY / 4) * CGFloat(j) + CGFloat(Int.random(in: Int(-frame.maxX / 20)...Int(frame.maxX / 20)))))
                    mViruses.append(newMainMenuVirus)
                }
            }
        }
        
        for virus in self.mViruses
        {
            virus.InitialiseMainMenuVirus(scene: self, zposition: 20)
        }
        
        mOptionsMenu.InitialiseOptionsMenu()
        mInfoMenu.InitialiseInfoMenu()
        
        print("Loading Main Menu")
        
        let MenuTitle = SKSpriteNode(imageNamed: mGameTitle)
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
        MenuTitle.position = CGPoint(x: frame.midX, y: frame.maxY - MenuTitle.frame.height / 1.5)
        MenuTitle.zPosition = 59
        
        addChild(MenuTitle)
        
        var Offset = CGFloat(-1)
        
        for ButtonName in mButtons {
            let MenuButton = Button(imageNamed: "Assets/MenuButtons/" + ButtonName)
            MenuButton.name = ButtonName
            MenuButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
            MenuButton.position = CGPoint(x: frame.midX + (Offset * MenuButton.frame.width * 1.2), y: frame.midY - MenuButton.frame.height / 2)
            MenuButton.zPosition = 60
            MenuButton.SetButtonPosition(to: MenuButton.position)
            
            Offset = Offset + CGFloat(2)
            
            addChild(MenuButton)
        }
        
        mOptionsMenu.ToggleOptionsMenu(to: false)
        
        mSceneLoadingComplete = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
        }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if !mOptionsMenuActive && !mInfoMenu.mInfoMenuActive
            {
                if touchedNode.name == mButtons[0]
                {
                    removeAllChildren()
                    
                    mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
                    mGameScene.scaleMode = .resizeFill
                    view?.presentScene(mGameScene, transition: .fade(withDuration: 0.5))
                }
                if touchedNode.name == mButtons[1]
                {
                    mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
                    mOptionsMenuActive = true
                    mOptionsMenu.ToggleOptionsMenu(to: true)
                }
            }

            let NodePressedName = String(touchedNode.name ?? "None")
            
            if mOptionsMenuActive
            {
                mOptionsMenu.UpdateOptionsMenu(pressed: NodePressedName)
            }
            
            mInfoMenu.UpdateInfoMenu(pressed: NodePressedName)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
     
        if(mDeltaTime == 0)
        {
            mDeltaTime = Double(0.015)
            mPrevTime = currentTime
        }
        else
        {
            mDeltaTime = currentTime - mPrevTime
            mPrevTime = currentTime
        }
        
        for virus in self.mViruses
        {
            virus.Update(rotationSpeed: 2)
        }

    }
    
    func GetDeltaTime() -> Double
    {
        return self.mDeltaTime
    }
    
}
