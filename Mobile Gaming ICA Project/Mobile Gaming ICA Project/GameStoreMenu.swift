//
//  GameStoreMenu.swift
//  Mobile Gaming ICA Project
//
//  Created by Tom on 04/12/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameStoreMenu
{

    var mGameScene : GameScene!
    
    let mStoreMenubackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    
    let MenuTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/StoreTitle-TB")
    
    let mStoreButton = Button(imageNamed: "Assets/MenuButtons/StoreButton-TB")
    let mCloseStoreButton = Button(imageNamed: "Assets/MenuButtons/ExitButton-TB")
    
    func SetupGameStore(scene GameScene: GameScene) {
        self.mGameScene = GameScene
    }
    
    func InitialiseStoreMenu()
    {
        mStoreMenubackground.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.midY)
        mStoreMenubackground.size = CGSize(width: 0, height: 0)
        mStoreMenubackground.zPosition = 98
        mStoreMenubackground.alpha = 0.5
        mGameScene.addChild(self.mStoreMenubackground)
        
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: self.mGameScene.frame.midX, height: self.mGameScene.frame.midX / 3)
        MenuTitle.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.maxY - MenuTitle.frame.height / 1.5)
        MenuTitle.zPosition = 99
        mGameScene.addChild(MenuTitle)
        
        mCloseStoreButton.name = "Close Store Button"
        mCloseStoreButton.size = CGSize(width: self.mGameScene.frame.maxX / 10, height: self.mGameScene.frame.maxX / 10)
        mCloseStoreButton.position = CGPoint(x: self.mGameScene.frame.maxX - (self.mCloseStoreButton.frame.width / 2 + 10), y: self.mGameScene.frame.maxY - (self.mCloseStoreButton.frame.height / 2 + 10))
        mCloseStoreButton.SetButtonPosition(to: self.mCloseStoreButton.position)
        mCloseStoreButton.zPosition = 100
        mGameScene.addChild(self.mCloseStoreButton)
        
        mStoreButton.name = "Store Button"
        mStoreButton.size = CGSize(width: self.mGameScene.frame.maxX / 10, height: self.mGameScene.frame.maxX / 10)
        mStoreButton.position = CGPoint(x: self.mGameScene.frame.maxX - (self.mStoreButton.frame.width / 2 + 10), y: self.mStoreButton.frame.height / 2 + 10)
        mStoreButton.SetButtonPosition(to: self.mStoreButton.position)
        mStoreButton.zPosition = 100
        mGameScene.addChild(self.mStoreButton)
        
        mStoreButton.SetButtonState(value: true)
        mCloseStoreButton.SetButtonState(value: false)
        
        ToggleStoreMenu(to: false)
    }
    
    func ToggleStoreMenu(to Value: Bool)
    {
        mGameScene.mStoreOpen = Value
        
        mStoreButton.SetButtonState(value: !Value)
        mCloseStoreButton.SetButtonState(value: Value)
        
        if Value
        {
            mGameScene.mPauseButton.SetButtonState(value: false)

            mStoreMenubackground.size = CGSize(width: self.mGameScene.frame.maxX, height: self.mGameScene.frame.maxY)
            MenuTitle.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.maxY - MenuTitle.frame.height / 1.5)
        }
        else
        {
            mGameScene.mPauseButton.SetButtonState(value: true)

            mStoreMenubackground.size = CGSize(width: 0, height: 0)
            MenuTitle.position = CGPoint(x: -1000, y: 0)
        }
    }
    
    func UpdateStoreMenu(pressed NodeName: String)
    {
        if NodeName == "Store Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            ToggleStoreMenu(to: true)
        }
        else if NodeName == "Close Store Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            ToggleStoreMenu(to: false)
        }
    }
    
}
