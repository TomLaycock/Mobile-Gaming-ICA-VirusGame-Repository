//
//  CustomSoundSystem.swift
//  Mobile Gaming ICA Project
//
//  Created by Tom on 06/12/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class CustomSoundSystem
{
    var ButtonZero : SKAction!
    var ButtonOne : SKAction!
    var SmallClick : SKAction!
    var ProjectileSelect : SKAction!
    var PowerUp : SKAction!
    var ProjectileShoot : SKAction!
    var CoinSound : SKAction!
    var HitSound : SKAction!
    var DeathSound : SKAction!
    
    //User Save Values
    let defaults = UserDefaults.standard
    
    //-------------------------------------------------------//
    //-------------------- System Setup ---------------------//
    //-------------------------------------------------------//
    
    func SetupCustomSoundSystem()
    {
        ButtonZero = SKAction.playSoundFileNamed("Sounds/ButtonClicks/Button-0000", waitForCompletion: true)
        ButtonOne = SKAction.playSoundFileNamed("Sounds/ButtonClicks/Button-0001", waitForCompletion: true)
        SmallClick = SKAction.playSoundFileNamed("Sounds/SmallClick", waitForCompletion: true)
        ProjectileSelect = SKAction.playSoundFileNamed("Sounds/ProjectileSelect", waitForCompletion: true)
        PowerUp = SKAction.playSoundFileNamed("Sounds/PowerUp", waitForCompletion: true)
        ProjectileShoot = SKAction.playSoundFileNamed("Sounds/Shoot", waitForCompletion: true)
        CoinSound = SKAction.playSoundFileNamed("Sounds/CoinSound", waitForCompletion: true)
        HitSound = SKAction.playSoundFileNamed("Sounds/Hit", waitForCompletion: true)
        DeathSound = SKAction.playSoundFileNamed("Sounds/WhiteBloodCellDeath", waitForCompletion: true)
    }
    
    //------------------------------------------------------------//
    //-------------------- System Functionality ------------------//
    //------------------------------------------------------------//

    func PlaySound(sound Sound: String, scene Scene: SKScene)
    {
        if !defaults.bool(forKey: "AudioToggleValue") { return }

        if Sound == "Button Zero"
        {
            Scene.run(self.ButtonZero)
        }
        else if Sound == "Button One"
        {
            Scene.run(self.ButtonOne)
        }
        else if Sound == "Small Click"
        {
            Scene.run(self.SmallClick)
        }
        else if Sound == "Projectile Select"
        {
            Scene.run(self.ProjectileSelect)
        }
        else if Sound == "Power Up"
        {
            Scene.run(self.PowerUp)
        }
        else if Sound == "Projectile Shoot"
        {
            Scene.run(self.ProjectileShoot)
        }
        else if Sound == "Coin"
        {
            Scene.run(self.CoinSound)
        }
        else if Sound == "Hit"
        {
            Scene.run(self.HitSound)
        }
        else if Sound == "Cell Death"
        {
            Scene.run(self.DeathSound)
        }
        else
        {
            print("Invalid Sound Name!")
        }

    }
    
}
