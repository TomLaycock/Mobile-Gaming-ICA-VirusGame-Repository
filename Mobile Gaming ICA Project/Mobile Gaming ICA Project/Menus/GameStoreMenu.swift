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
    
    var mProjectileOneQuantity = 0
    {
        didSet
        {
            mGameScene.mProjectileOneQuantityLabel.text = String(mProjectileOneQuantity)
            mProjectileOneBuyQuantity.text = String(mProjectileOneQuantity)
        }
    }
    
    var mProjectileTwoQuantity = 0
    {
        didSet
        {
            mGameScene.mProjectileTwoQuantityLabel.text = String(mProjectileTwoQuantity)
            mProjectileTwoBuyQuantity.text = String(mProjectileTwoQuantity)
        }
    }
    var mProjectileThreeQuantity = 0
    {
        didSet
        {
            mGameScene.mProjectileThreeQuantityLabel.text = String(mProjectileThreeQuantity)
            mProjectileThreeBuyQuantity.text = String(mProjectileThreeQuantity)
        }
    }
    
    let mProjectileOneBuyButton = Button(imageNamed: "Assets/Projectiles/Projectile-0000")
    let mProjectileTwoBuyButton = Button(imageNamed: "Assets/Projectiles/Projectile-0001")
    let mProjectileThreeBuyButton = Button(imageNamed: "Assets/Projectiles/Projectile-0002")
    
    let mProjectileOneBuyQuantity = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mProjectileTwoBuyQuantity = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mProjectileThreeBuyQuantity = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    func SetupGameStore(scene GameScene: GameScene) {
        self.mGameScene = GameScene
    }
    
    func InitialiseStoreMenu()
    {
        //Initialising default values for thhe Game Store Buttons / Images and Text
        mStoreMenubackground.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.midY)
        mStoreMenubackground.size = CGSize(width: 0, height: 0)
        mStoreMenubackground.zPosition = 98
        mStoreMenubackground.alpha = 0.8
        mGameScene.addChild(self.mStoreMenubackground)
        
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: (self.mGameScene.frame.height / 1.5), height: (self.mGameScene.frame.height / 3) / 1.5)
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
        
        mProjectileOneQuantity = 0
        mProjectileTwoQuantity = 0
        mProjectileThreeQuantity = 0
        
        //------------------------------------------------------------//
        //-------------------- Setting Up Store Buttons --------------//
        //------------------------------------------------------------//

        let ScreenWidth = self.mGameScene.frame.maxX
        let ScreenHeight = self.mGameScene.frame.maxY
        
        let ProjectileButtonsSize = CGFloat(ScreenHeight / 5)
        
        mProjectileOneBuyButton.position = CGPoint(x: (ScreenWidth / 2) - ProjectileButtonsSize - 20, y: (ScreenHeight / 2))
        mProjectileOneBuyButton.zPosition = 100
        mProjectileOneBuyButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileOneBuyButton.name = "Projectile One Buy Button"
        mProjectileOneBuyButton.SetButtonPosition(to: mProjectileOneBuyButton.position)
        self.mGameScene.addChild(mProjectileOneBuyButton)
        
        mProjectileTwoBuyButton.position = CGPoint(x: (ScreenWidth / 2), y: (ScreenHeight / 2))
        mProjectileTwoBuyButton.zPosition = 100
        mProjectileTwoBuyButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileTwoBuyButton.name = "Projectile Two Buy Button"
        mProjectileTwoBuyButton.SetButtonPosition(to: mProjectileTwoBuyButton.position)
        self.mGameScene.addChild(mProjectileTwoBuyButton)
        
        mProjectileThreeBuyButton.position = CGPoint(x: (ScreenWidth / 2) + ProjectileButtonsSize + 20, y: (ScreenHeight / 2))
        mProjectileThreeBuyButton.zPosition = 100
        mProjectileThreeBuyButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileThreeBuyButton.name = "Projectile Three Buy Button"
        mProjectileThreeBuyButton.SetButtonPosition(to: mProjectileThreeBuyButton.position)
        self.mGameScene.addChild(mProjectileThreeBuyButton)

        mProjectileOneBuyButton.SetButtonState(value: false)
        mProjectileTwoBuyButton.SetButtonState(value: false)
        mProjectileThreeBuyButton.SetButtonState(value: false)
        
        
        
        mProjectileOneBuyQuantity.fontSize = 40
        mProjectileOneBuyQuantity.position = CGPoint(x: (ScreenWidth / 2) - ProjectileButtonsSize - 20, y: (ScreenHeight / 2) + (ProjectileButtonsSize / 2))
        mProjectileOneBuyQuantity.text = "0"
        mProjectileOneBuyQuantity.zPosition = 101
        mProjectileOneBuyQuantity.horizontalAlignmentMode = .center
        mProjectileOneBuyQuantity.isUserInteractionEnabled = false
        self.mGameScene.addChild(mProjectileOneBuyQuantity)
        
        mProjectileTwoBuyQuantity.fontSize = 40
        mProjectileTwoBuyQuantity.position = CGPoint(x: (ScreenWidth / 2), y: (ScreenHeight / 2) + (ProjectileButtonsSize / 2))
        mProjectileTwoBuyQuantity.text = "0"
        mProjectileTwoBuyQuantity.zPosition = 101
        mProjectileTwoBuyQuantity.horizontalAlignmentMode = .center
        mProjectileTwoBuyQuantity.isUserInteractionEnabled = false
        self.mGameScene.addChild(mProjectileTwoBuyQuantity)
        
        mProjectileThreeBuyQuantity.fontSize = 40
        mProjectileThreeBuyQuantity.position = CGPoint(x: (ScreenWidth / 2) + ProjectileButtonsSize + 20, y: (ScreenHeight / 2) + (ProjectileButtonsSize / 2))
        mProjectileThreeBuyQuantity.text = "0"
        mProjectileThreeBuyQuantity.zPosition = 101
        mProjectileThreeBuyQuantity.horizontalAlignmentMode = .center
        mProjectileThreeBuyQuantity.isUserInteractionEnabled = false
        self.mGameScene.addChild(mProjectileThreeBuyQuantity)
        
        mProjectileOneBuyQuantity.isHidden = true
        mProjectileTwoBuyQuantity.isHidden = true
        mProjectileThreeBuyQuantity.isHidden = true
        
        ToggleStoreMenu(to: false)
    }
    
    //Toggle the Store menu to be open or closed
    func ToggleStoreMenu(to Value: Bool)
    {
        mGameScene.mStoreOpen = Value
        
        mStoreButton.SetButtonState(value: !Value)
        mCloseStoreButton.SetButtonState(value: Value)
        
        if Value
        {
            mGameScene.mPauseButton.SetButtonState(value: false)
            
            mProjectileOneBuyButton.SetButtonState(value: true)
            mProjectileTwoBuyButton.SetButtonState(value: true)
            mProjectileThreeBuyButton.SetButtonState(value: true)
            
            mProjectileOneBuyQuantity.isHidden = false
            mProjectileTwoBuyQuantity.isHidden = false
            mProjectileThreeBuyQuantity.isHidden = false

            mStoreMenubackground.size = CGSize(width: self.mGameScene.frame.maxX, height: self.mGameScene.frame.maxY)
            MenuTitle.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.maxY - MenuTitle.frame.height / 1.5)
        }
        else
        {
            mGameScene.mPauseButton.SetButtonState(value: true)

            mProjectileOneBuyButton.SetButtonState(value: false)
            mProjectileTwoBuyButton.SetButtonState(value: false)
            mProjectileThreeBuyButton.SetButtonState(value: false)
            
            mProjectileOneBuyQuantity.isHidden = true
            mProjectileTwoBuyQuantity.isHidden = true
            mProjectileThreeBuyQuantity.isHidden = true
            
            mStoreMenubackground.size = CGSize(width: 0, height: 0)
            MenuTitle.position = CGPoint(x: -1000, y: 0)
        }
    }
    
    func UpdateStoreMenu(pressed NodeName: String)
    {
        if NodeName == "Store Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mGameScene)
            ToggleStoreMenu(to: true)
        }
        else if NodeName == "Close Store Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mGameScene)
            ToggleStoreMenu(to: false)
        }
        
        //Buy Buttons
        if NodeName == "Projectile One Buy Button"
        {
            if mGameScene.mScore >= 1
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Coin", scene: mGameScene)
                mGameScene.mScore = mGameScene.mScore - 1
                mProjectileOneQuantity = mProjectileOneQuantity + 1
            }
            else
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Small Click", scene: mGameScene)
            }
        }
        else if NodeName == "Projectile Two Buy Button"
        {
            if mGameScene.mScore >= 5
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Coin", scene: mGameScene)
                mGameScene.mScore = mGameScene.mScore - 5
                mProjectileTwoQuantity = mProjectileTwoQuantity + 1
            }
            else
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Small Click", scene: mGameScene)
            }
        }
        else if NodeName == "Projectile Three Buy Button"
        {
            if mGameScene.mScore >= 10
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Coin", scene: mGameScene)
                mGameScene.mScore = mGameScene.mScore - 10
                mProjectileThreeQuantity = mProjectileThreeQuantity + 1
            }
            else
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Small Click", scene: mGameScene)
            }
        }
    }
    
}
