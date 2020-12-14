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

class InfoMenu
{

    var mMainMenu : MainMenu!
    
    let DivisionFactor = 7
    var mTextScale = CGFloat(0)
    
    var mInfoMenuActive = false
    
    let mInfoMenuBackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    
    let MenuTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/HowToPlayTitle-TB")
    
    let mOpenInfoMenuButton = Button(imageNamed: "Assets/MenuButtons/InfoButton-TB")
    let mCloseInfoMenuButton = Button(imageNamed: "Assets/MenuButtons/ExitButton-TB")

    let mEnergyBallInfoImage = SKSpriteNode(imageNamed: "Assets/Energy/BasicFood")
    let mEnergyBallInfoText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mWhiteBloodCellInfoImage = SKSpriteNode(imageNamed: "Assets/Viruses/WhiteBloodCell-0000")
    let mWhiteBloodCellInfoText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mBossInfoImage = SKSpriteNode(imageNamed: "Assets/Viruses/WhiteBloodCell-0001")
    let mBossInfoText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mProjectileInfoImage = SKSpriteNode(imageNamed: "Assets/Projectiles/Projectile-0000")
    let mProjectileInfoText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    func SetupInfoMenu(scene MainMenu: MainMenu) {
        self.mMainMenu = MainMenu
    }

    func InitialiseInfoMenu()
    {
        //Initialisng default values for buttons / images and text
        let ScreenWidth = self.mMainMenu.frame.maxX
        let ScreenHeight = self.mMainMenu.frame.maxY
        
        mTextScale = CGFloat(ScreenWidth / 32)
        
        mInfoMenuBackground.position = CGPoint(x: self.mMainMenu.frame.midX, y: self.mMainMenu.frame.midY)
        mInfoMenuBackground.size = CGSize(width: ScreenWidth, height: ScreenHeight)
        mInfoMenuBackground.zPosition = 98
        mInfoMenuBackground.alpha = 0.8
        mMainMenu.addChild(self.mInfoMenuBackground)
        mInfoMenuBackground.isHidden = true
        
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: self.mMainMenu.frame.height, height: self.mMainMenu.frame.height / 5)
        MenuTitle.position = CGPoint(x: self.mMainMenu.frame.midX, y: self.mMainMenu.frame.maxY - MenuTitle.frame.height / 1.5)
        MenuTitle.zPosition = 99
        mMainMenu.addChild(MenuTitle)
        MenuTitle.isHidden = true
        
        mOpenInfoMenuButton.name = "Open Info Menu Button"
        mOpenInfoMenuButton.size = CGSize(width: self.mMainMenu.frame.maxX / 10, height: self.mMainMenu.frame.maxX / 10)
        mOpenInfoMenuButton.position = CGPoint(x: (self.mOpenInfoMenuButton.frame.width / 2 + 10), y: self.mMainMenu.frame.maxY - (self.mOpenInfoMenuButton.frame.height / 2 + 10))
        mOpenInfoMenuButton.SetButtonPosition(to: self.mOpenInfoMenuButton.position)
        mOpenInfoMenuButton.zPosition = 60
        mMainMenu.addChild(self.mOpenInfoMenuButton)
        mOpenInfoMenuButton.SetButtonState(value: true)
        
        mCloseInfoMenuButton.name = "Close Info Menu Button"
        mCloseInfoMenuButton.size = CGSize(width: self.mMainMenu.frame.maxX / 10, height: self.mMainMenu.frame.maxX / 10)
        mCloseInfoMenuButton.position = CGPoint(x: self.mMainMenu.frame.maxX - (self.mCloseInfoMenuButton.frame.width / 2 + 10), y: self.mMainMenu.frame.maxY - (self.mCloseInfoMenuButton.frame.height / 2 + 10))
        mCloseInfoMenuButton.SetButtonPosition(to: self.mCloseInfoMenuButton.position)
        mCloseInfoMenuButton.zPosition = 100
        mMainMenu.addChild(self.mCloseInfoMenuButton)
        mCloseInfoMenuButton.SetButtonState(value: false)
        
        //------------------------------------------------------------//
        //-------------------- Setting Up Info Objects ---------------//
        //------------------------------------------------------------//
        let ImageWidth = (ScreenHeight / CGFloat(DivisionFactor))
        
        mEnergyBallInfoImage.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4), y: (ScreenHeight / 2) + (ImageWidth * 1))
        ApplyCommonSettingsToImage(to: mEnergyBallInfoImage)

        mEnergyBallInfoText.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4) + ImageWidth, y: (ScreenHeight / 2) + (ImageWidth * 1))
        mEnergyBallInfoText.text = "Eat Food to gain Energy!"
        ApplyCommonSettingsToText(to: mEnergyBallInfoText)

        
        
        mWhiteBloodCellInfoImage.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4), y: (ScreenHeight / 2))
        ApplyCommonSettingsToImage(to: mWhiteBloodCellInfoImage)

        mWhiteBloodCellInfoText.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4) + ImageWidth, y: (ScreenHeight / 2))
        mWhiteBloodCellInfoText.text = "White Blood Cell - 1HP"
        ApplyCommonSettingsToText(to: mWhiteBloodCellInfoText)
        
        
        
        mBossInfoImage.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4), y: (ScreenHeight / 2) - (ImageWidth * 1))
        ApplyCommonSettingsToImage(to: mBossInfoImage)

        mBossInfoText.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4) + ImageWidth, y: (ScreenHeight / 2) - (ImageWidth * 1))
        mBossInfoText.text = "Boss White Blood Cell - 150HP"
        ApplyCommonSettingsToText(to: mBossInfoText)
        
        
        
        mProjectileInfoImage.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4), y: (ScreenHeight / 2) - (ImageWidth * 2))
        ApplyCommonSettingsToImage(to: mProjectileInfoImage)

        mProjectileInfoText.position = CGPoint(x: (ScreenWidth / 2) - (ScreenWidth / 4) + ImageWidth, y: (ScreenHeight / 2) - (ImageWidth * 2))
        mProjectileInfoText.text = "Fire these at White Blood Cells and Boss Cells!"
        ApplyCommonSettingsToText(to: mProjectileInfoText)
        
        ToggleInfoMenu(to: false)
    }
    
    //Functions for applying common settings to each of the Images / Text / Buttons
    func ApplyCommonSettingsToImage(to Image: SKSpriteNode)
    {
        let ImageWidth = (self.mMainMenu.frame.height / CGFloat(DivisionFactor))
        
        Image.zPosition = 100
        Image.size = CGSize(width: ImageWidth, height: ImageWidth)
        Image.isUserInteractionEnabled = false
        Image.isHidden = true
        self.mMainMenu.addChild(Image)
    }
    
    func ApplyCommonSettingsToText(to Text: SKLabelNode)
    {
        Text.fontSize = mTextScale
        Text.zPosition = 100
        Text.horizontalAlignmentMode = .left
        Text.verticalAlignmentMode = .center
        Text.isUserInteractionEnabled = false
        Text.isHidden = true
        self.mMainMenu.addChild(Text)
    }
    
    //Toggles Info menu to be open or closed
    func ToggleInfoMenu(to Value: Bool)
    {
        mInfoMenuActive = Value
        
        mInfoMenuBackground.isHidden = !Value
        mOpenInfoMenuButton.SetButtonState(value: !Value)
        MenuTitle.isHidden = !Value
        
        mEnergyBallInfoImage.isHidden = !Value
        mEnergyBallInfoText.isHidden = !Value
        
        mWhiteBloodCellInfoImage.isHidden = !Value
        mWhiteBloodCellInfoText.isHidden = !Value
        
        mBossInfoImage.isHidden = !Value
        mBossInfoText.isHidden = !Value
        
        mProjectileInfoImage.isHidden = !Value
        mProjectileInfoText.isHidden = !Value
        
        mCloseInfoMenuButton.SetButtonState(value: Value)
    }
    
    func UpdateInfoMenu(pressed NodeName: String)
    {
        if NodeName == "Open Info Menu Button"
        {
            mMainMenu.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMainMenu)
            ToggleInfoMenu(to: true)
        }
        else if NodeName == "Close Info Menu Button"
        {
            mMainMenu.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMainMenu)
            ToggleInfoMenu(to: false)
        }
    }
    
}
