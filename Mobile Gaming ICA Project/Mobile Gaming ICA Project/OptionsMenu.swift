//
//  OptionsMenu.swift
//  Mobile Gaming ICA Project
//
//  Created by Tom on 06/12/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class OptionsMenu
{

    var mGameScene : GameScene!
    
    let mOptionsMenubackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    
    let MenuTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/OptionsTitle-TB")

    let mCloseOptionsMenuButton = Button(imageNamed: "Assets/MenuButtons/ExitButton-TB")
    
    let mAudioOn = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mAlternateControls = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    var mAudioValue = true
    var mAlternateControlsValue = false
    
    let mAudioToggleButtonOn = Button(imageNamed: "Assets/OptionsMenuButtons/OnButton")
    let mAudioToggleButtonOff = Button(imageNamed: "Assets/OptionsMenuButtons/OffButton")
    
    let mAlternateControlsButtonOn = Button(imageNamed: "Assets/OptionsMenuButtons/OnButton")
    let mAlternateControlsButtonOff = Button(imageNamed: "Assets/OptionsMenuButtons/OffButton")
    
    func SetupGameOptionsMenu(scene GameScene: GameScene, audioOn AudioValue: Bool, altOn AltValue: Bool) {
        self.mGameScene = GameScene
        
        mAudioValue = AudioValue
        mAlternateControlsValue = AltValue
    }
    
    func InitialiseOptionsMenu()
    {
        mAudioValue = mGameScene.defaults.bool(forKey: "AudioToggleValue")
        mAlternateControlsValue = mGameScene.defaults.bool(forKey: "AltToggleValue")
        
        mOptionsMenubackground.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.midY)
        mOptionsMenubackground.size = CGSize(width: 0, height: 0)
        mOptionsMenubackground.zPosition = 98
        mOptionsMenubackground.alpha = 0.8
        mGameScene.addChild(self.mOptionsMenubackground)
        
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: self.mGameScene.frame.midX, height: self.mGameScene.frame.midX / 3)
        MenuTitle.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.maxY - MenuTitle.frame.height / 1.5)
        MenuTitle.zPosition = 99
        mGameScene.addChild(MenuTitle)
        
        mCloseOptionsMenuButton.name = "Close Options Menu Button"
        mCloseOptionsMenuButton.size = CGSize(width: self.mGameScene.frame.maxX / 10, height: self.mGameScene.frame.maxX / 10)
        mCloseOptionsMenuButton.position = CGPoint(x: self.mGameScene.frame.maxX - (self.mCloseOptionsMenuButton.frame.width / 2 + 10), y: self.mGameScene.frame.maxY - (self.mCloseOptionsMenuButton.frame.height / 2 + 10))
        mCloseOptionsMenuButton.SetButtonPosition(to: self.mCloseOptionsMenuButton.position)
        mCloseOptionsMenuButton.zPosition = 100
        mGameScene.addChild(self.mCloseOptionsMenuButton)
        
        //Audio Button
        EditButtonSettings(for: mAudioToggleButtonOn, name: "Audio On Button", pos: -12)
        mGameScene.addChild(mAudioToggleButtonOn)
        
        EditButtonSettings(for: mAudioToggleButtonOff, name: "Audio Off Button", pos: -12)
        mGameScene.addChild(mAudioToggleButtonOff)
        
        //Alternate Button
        EditButtonSettings(for: mAlternateControlsButtonOn, name: "Alt On Button", pos: -100)
        mGameScene.addChild(mAlternateControlsButtonOn)
        
        EditButtonSettings(for: mAlternateControlsButtonOff, name: "Alt Off Button", pos: -100)
        mGameScene.addChild(mAlternateControlsButtonOff)
        
        //Defaulting Text
        mAudioOn.fontSize = 50
        mAudioOn.position = CGPoint(x: -1000, y: 0)
        mAudioOn.text = "Audio: "
        mAudioOn.zPosition = 100
        mAudioOn.horizontalAlignmentMode = .right
        mGameScene.addChild(mAudioOn)
        
        mAlternateControls.fontSize = 50
        mAlternateControls.position = CGPoint(x: -1000, y: 0)
        mAlternateControls.text = "Touch Screen Controls:"
        mAlternateControls.zPosition = 100
        mAlternateControls.horizontalAlignmentMode = .right
        mGameScene.addChild(mAlternateControls)
        
        
        //Defaulting Buttons
        mCloseOptionsMenuButton.SetButtonState(value: false)
        
        mAudioToggleButtonOn.SetButtonState(value: false)
        mAudioToggleButtonOff.SetButtonState(value: false)
        
        mAlternateControlsButtonOn.SetButtonState(value: false)
        mAlternateControlsButtonOff.SetButtonState(value: false)
        
        ToggleOptionsMenu(to: false)
    }
    
    func ToggleOptionsMenu(to Value: Bool)
    {
        mGameScene.mGameOptionsMenu = Value
        
        mCloseOptionsMenuButton.SetButtonState(value: Value)
        
        if Value
        {
            mGameScene.mPauseButton.SetButtonState(value: false)

            mOptionsMenubackground.size = CGSize(width: self.mGameScene.frame.maxX, height: self.mGameScene.frame.maxY)
            MenuTitle.position = CGPoint(x: self.mGameScene.frame.midX, y: self.mGameScene.frame.maxY - MenuTitle.frame.height / 1.5)
            
            mAudioOn.position = CGPoint(x: mGameScene.frame.midX + (mAudioOn.frame.width / 0.8), y: mGameScene.frame.midY - 25)
            mAlternateControls.position = CGPoint(x: mGameScene.frame.midX + (mAudioOn.frame.width / 0.8), y: mGameScene.frame.midY - 110)
            
            if mAudioValue
            {
                mAudioToggleButtonOn.SetButtonState(value: false)
                mAudioToggleButtonOff.SetButtonState(value: true)
            }
            else
            {
                mAudioToggleButtonOn.SetButtonState(value: true)
                mAudioToggleButtonOff.SetButtonState(value: false)
            }
            
            if mAlternateControlsValue
            {
                mAlternateControlsButtonOn.SetButtonState(value: false)
                mAlternateControlsButtonOff.SetButtonState(value: true)
            }
            else
            {
                mAlternateControlsButtonOn.SetButtonState(value: true)
                mAlternateControlsButtonOff.SetButtonState(value: false)
            }
        }
        else
        {
            mGameScene.mPauseButton.SetButtonState(value: true)

            mOptionsMenubackground.size = CGSize(width: 0, height: 0)
            MenuTitle.position = CGPoint(x: -1000, y: 0)
            
            mAudioOn.position = CGPoint(x: -1000, y: 0)
            mAlternateControls.position = CGPoint(x: -1000, y: 0)
            
            mAudioToggleButtonOn.SetButtonState(value: false)
            mAudioToggleButtonOff.SetButtonState(value: false)
            
            mAlternateControlsButtonOn.SetButtonState(value: false)
            mAlternateControlsButtonOff.SetButtonState(value: false)
        }
    }
    
    func UpdateOptionsMenu(pressed NodeName: String)
    {
        if NodeName == "Close Options Menu Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            mGameScene.TogglePauseMenuSpecifc(to: true)
            ToggleOptionsMenu(to: false)
            
            mGameScene.mPauseButton.SetButtonState(value: false)
            mGameScene.mStoreMenu.mStoreButton.SetButtonState(value: false)
        }
        else if NodeName == "Audio On Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            mAudioValue = true
            mAudioToggleButtonOn.SetButtonState(value: false)
            mAudioToggleButtonOff.SetButtonState(value: true)
            mGameScene.defaults.set(true, forKey: "AudioToggleValue")
            print("Toggle Audio On")
        }
        else if NodeName == "Audio Off Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            mAudioValue = false
            mAudioToggleButtonOn.SetButtonState(value: true)
            mAudioToggleButtonOff.SetButtonState(value: false)
            mGameScene.defaults.set(false, forKey: "AudioToggleValue")
            print("Toggle Audio Off")
        }
        else if NodeName == "Alt On Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            mAlternateControlsValue = true
            mAlternateControlsButtonOn.SetButtonState(value: false)
            mAlternateControlsButtonOff.SetButtonState(value: true)
            mGameScene.defaults.set(true, forKey: "AltToggleValue")
            print("Toggle Alt On")
        }
        else if NodeName == "Alt Off Button"
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Button-0000")
            mAlternateControlsValue = false
            mAlternateControlsButtonOn.SetButtonState(value: true)
            mAlternateControlsButtonOff.SetButtonState(value: false)
            mGameScene.defaults.set(false, forKey: "AltToggleValue")
            print("Toggle Alt Off")
        }
    }
    
    func EditButtonSettings(for Button: Button, name Name: String, pos Position: CGFloat)
    {
        Button.name = Name
        Button.size = CGSize(width: mGameScene.frame.maxX / 15, height: mGameScene.frame.maxX / 15)
        Button.position = CGPoint(x: mGameScene.frame.midX + (Button.frame.width * 3) + 20, y: mGameScene.frame.midY + Position)
        Button.SetButtonPosition(to: Button.position)
        Button.zPosition = 100
    }
    
}