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

class MainOptionsMenu
{

    var mMenuScene : MainMenu!
    
    var mTextScale = CGFloat(0)
    
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
    
    func SetupGameOptionsMenu(scene MenuScene: MainMenu, audioOn AudioValue: Bool, altOn AltValue: Bool) {
        self.mMenuScene = MenuScene
        
        mAudioValue = AudioValue
        mAlternateControlsValue = AltValue
    }
    
    func InitialiseOptionsMenu()
    {
        //Initialising Default values for the options menu
        mTextScale = CGFloat(mMenuScene.frame.maxX / 32)
        
        mAudioValue = mMenuScene.defaults.bool(forKey: "AudioToggleValue")
        mAlternateControlsValue = mMenuScene.defaults.bool(forKey: "AltToggleValue")
        
        mOptionsMenubackground.position = CGPoint(x: self.mMenuScene.frame.midX, y: self.mMenuScene.frame.midY)
        mOptionsMenubackground.size = CGSize(width: 0, height: 0)
        mOptionsMenubackground.zPosition = 98
        mOptionsMenubackground.alpha = 0.8
        mMenuScene.addChild(self.mOptionsMenubackground)
        
        MenuTitle.name = "MenuTitle"
        MenuTitle.size = CGSize(width: (self.mMenuScene.frame.height / 1.5), height: (self.mMenuScene.frame.height / 3) / 1.5)
        MenuTitle.position = CGPoint(x: self.mMenuScene.frame.midX, y: self.mMenuScene.frame.maxY - MenuTitle.frame.height / 1.5)
        MenuTitle.zPosition = 99
        mMenuScene.addChild(MenuTitle)
        
        mCloseOptionsMenuButton.name = "Close Options Menu Button"
        mCloseOptionsMenuButton.size = CGSize(width: self.mMenuScene.frame.maxX / 10, height: self.mMenuScene.frame.maxX / 10)
        mCloseOptionsMenuButton.position = CGPoint(x: self.mMenuScene.frame.maxX - (self.mCloseOptionsMenuButton.frame.width / 2 + 10), y: self.mMenuScene.frame.maxY - (self.mCloseOptionsMenuButton.frame.height / 2 + 10))
        mCloseOptionsMenuButton.SetButtonPosition(to: self.mCloseOptionsMenuButton.position)
        mCloseOptionsMenuButton.zPosition = 100
        mMenuScene.addChild(self.mCloseOptionsMenuButton)
        
        //Audio Button
        EditButtonSettings(for: mAudioToggleButtonOn, name: "Audio On Button", pos: 0)
        mMenuScene.addChild(mAudioToggleButtonOn)
        
        EditButtonSettings(for: mAudioToggleButtonOff, name: "Audio Off Button", pos: 0)
        mMenuScene.addChild(mAudioToggleButtonOff)
        
        //Alternate Button
        EditButtonSettings(for: mAlternateControlsButtonOn, name: "Alt On Button", pos: 1)
        mMenuScene.addChild(mAlternateControlsButtonOn)
        
        EditButtonSettings(for: mAlternateControlsButtonOff, name: "Alt Off Button", pos: 1)
        mMenuScene.addChild(mAlternateControlsButtonOff)
        
        //Defaulting Text
        mAudioOn.fontSize = mTextScale * 1.3
        mAudioOn.position = CGPoint(x: -1000, y: 0)
        mAudioOn.text = "Audio: "
        mAudioOn.zPosition = 100
        mAudioOn.horizontalAlignmentMode = .right
        mMenuScene.addChild(mAudioOn)
        
        mAlternateControls.fontSize = mTextScale * 1.3
        mAlternateControls.position = CGPoint(x: -1000, y: 0)
        mAlternateControls.text = "Touch Screen Controls:"
        mAlternateControls.zPosition = 100
        mAlternateControls.horizontalAlignmentMode = .right
        mMenuScene.addChild(mAlternateControls)
        
        mAudioOn.verticalAlignmentMode = .center
        mAlternateControls.verticalAlignmentMode = .center
        
        //Defaulting Buttons
        mCloseOptionsMenuButton.SetButtonState(value: false)
        
        mAudioToggleButtonOn.SetButtonState(value: false)
        mAudioToggleButtonOff.SetButtonState(value: false)
        
        mAlternateControlsButtonOn.SetButtonState(value: false)
        mAlternateControlsButtonOff.SetButtonState(value: false)
        
        ToggleOptionsMenu(to: false)
    }
    
    //Opens / Closes the options menu
    func ToggleOptionsMenu(to Value: Bool)
    {
        mCloseOptionsMenuButton.SetButtonState(value: Value)
        
        if Value
        {
            mOptionsMenubackground.size = CGSize(width: self.mMenuScene.frame.maxX, height: self.mMenuScene.frame.maxY)
            MenuTitle.position = CGPoint(x: self.mMenuScene.frame.midX, y: self.mMenuScene.frame.maxY - MenuTitle.frame.height / 1.5)
            
            mAudioOn.position = CGPoint(x: mMenuScene.frame.midX + ((mMenuScene.frame.maxY / 7) * 1), y: mMenuScene.frame.midY)
            mAlternateControls.position = CGPoint(x: mMenuScene.frame.midX + ((mMenuScene.frame.maxY / 7) * 1), y: mMenuScene.frame.midY - (mMenuScene.frame.maxY / 7))
            
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
            
            if mAlternateControlsValue //Setting buttons states for saved value objects
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
            mMenuScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMenuScene)
            mMenuScene.mOptionsMenuActive = false
            ToggleOptionsMenu(to: false)
        }
        else if NodeName == "Audio On Button"
        {
            mMenuScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMenuScene)
            mAudioValue = true
            mAudioToggleButtonOn.SetButtonState(value: false)
            mAudioToggleButtonOff.SetButtonState(value: true)
            mMenuScene.defaults.set(true, forKey: "AudioToggleValue")
            print("Toggle Audio On")
        }
        else if NodeName == "Audio Off Button"
        {
            mMenuScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMenuScene)
            mAudioValue = false
            mAudioToggleButtonOn.SetButtonState(value: true)
            mAudioToggleButtonOff.SetButtonState(value: false)
            mMenuScene.defaults.set(false, forKey: "AudioToggleValue")
            print("Toggle Audio Off")
        }
        else if NodeName == "Alt On Button"
        {
            mMenuScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMenuScene)
            mAlternateControlsValue = true
            mAlternateControlsButtonOn.SetButtonState(value: false)
            mAlternateControlsButtonOff.SetButtonState(value: true)
            mMenuScene.defaults.set(true, forKey: "AltToggleValue")
            print("Toggle Alt On")
        }
        else if NodeName == "Alt Off Button"
        {
            mMenuScene.mSoundSystem.PlaySound(sound: "Button Zero", scene: mMenuScene)
            mAlternateControlsValue = false
            mAlternateControlsButtonOn.SetButtonState(value: true)
            mAlternateControlsButtonOff.SetButtonState(value: false)
            mMenuScene.defaults.set(false, forKey: "AltToggleValue")
            print("Toggle Alt Off")
        }
    }
    
    //Setting basic default settings for each button
    func EditButtonSettings(for Button: Button, name Name: String, pos Position: CGFloat)
    {
        Button.name = Name
        Button.size = CGSize(width: mMenuScene.frame.maxY / 7, height: mMenuScene.frame.maxY / 7)
        Button.position = CGPoint(x: mMenuScene.frame.midX + (Button.frame.width * 1.5) + 20, y: mMenuScene.frame.midY + (Position * -(mMenuScene.frame.maxY / 7)))
        Button.SetButtonPosition(to: Button.position)
        Button.zPosition = 100
    }
    
}
