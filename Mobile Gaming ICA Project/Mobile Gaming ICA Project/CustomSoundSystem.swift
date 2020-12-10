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

    var mSoundDict = Dictionary<String, AVAudioPlayer>()
    
    var mProjectileShotPool : [AVAudioPlayer] = []
    var mCoinSoundPool : [AVAudioPlayer] = []
    var mHitSoundPool : [AVAudioPlayer] = []
    var mCellDeathSoundPool : [AVAudioPlayer] = []
    
    //User Save Values
    let defaults = UserDefaults.standard
    
    //-------------------------------------------------------//
    //-------------------- System Setup ---------------------//
    //-------------------------------------------------------//
    
    func SetupCustomSoundSystem()
    {
        let Button0000 = Bundle.main.path(forResource: "Sounds/ButtonClicks/Button-0000", ofType: "wav")
        do {
            mSoundDict["Button-0000"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Button0000!))
        } catch {
            print(error)
        }
        
        let Button0001 = Bundle.main.path(forResource: "Sounds/ButtonClicks/Button-0001", ofType: "wav")
        do {
            mSoundDict["Button-0001"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Button0001!))
        } catch {
            print(error)
        }
        
        let SmallClick = Bundle.main.path(forResource: "Sounds/SmallClick", ofType: "mp3")
        do {
            mSoundDict["SmallClick"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: SmallClick!))
        } catch {
            print(error)
        }
        
        let ProjectileSelect = Bundle.main.path(forResource: "Sounds/ProjectileSelect", ofType: "mp3")
        do {
            mSoundDict["ProjectileSelect"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ProjectileSelect!))
        } catch {
            print(error)
        }
        
        let PowerUp = Bundle.main.path(forResource: "Sounds/PowerUp", ofType: "wav")
        do {
            mSoundDict["PowerUp"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: PowerUp!))
        } catch {
            print(error)
        }
        
        SetupSoundPools()
    }
    
    //Setup Sound Pools
    func SetupSoundPools()
    {
        //Projectile Shoot Sound
        let mProjectileShot = Bundle.main.path(forResource: "Sounds/Shoot", ofType: "wav")
        
        for _ in 1...10
        {
            do {
                let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mProjectileShot!))
                mProjectileShotPool.append(newAudioPlayer)
            } catch {
                print(error)
            }
        }
        
        //Coin Sound
        let mCoinSound = Bundle.main.path(forResource: "Sounds/CoinSound", ofType: "wav")
        
        for _ in 1...10
        {
            do {
                let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mCoinSound!))
                mCoinSoundPool.append(newAudioPlayer)
            } catch {
                print(error)
            }
        }
        
        //Hit Sound
        let mHitSound = Bundle.main.path(forResource: "Sounds/Hit", ofType: "wav")
        
        for _ in 1...10
        {
            do {
                let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mHitSound!))
                mHitSoundPool.append(newAudioPlayer)
            } catch {
                print(error)
            }
        }
        
        //Cell Death Sound
        let mCellDeathSound = Bundle.main.path(forResource: "Sounds/WhiteBloodCellDeath", ofType: "wav")
        
        for _ in 1...10
        {
            do {
                let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mCellDeathSound!))
                mCellDeathSoundPool.append(newAudioPlayer)
            } catch {
                print(error)
            }
        }
    }
    
    
    //------------------------------------------------------------//
    //-------------------- System Get Sounds ---------------------//
    //------------------------------------------------------------//
    
    func GetNextAvailableProjectileShotSound() -> AVAudioPlayer
    {
        for sound in mProjectileShotPool
        {
            if !sound.isPlaying { return sound }
        }
        
        let mProjectileShot = Bundle.main.path(forResource: "Sounds/Shoot", ofType: "wav")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mProjectileShot!))
            mProjectileShotPool.append(newAudioPlayer)
            
            return newAudioPlayer
        } catch {
            print(error)
        }

        print("Returning Element 0 of Sound System Pool - Failed to create new sound!")
        
        return mProjectileShotPool[0]
    }
    
    func GetNextAvailableCoinSound() -> AVAudioPlayer
    {
        for sound in mCoinSoundPool
        {
            if !sound.isPlaying { return sound }
        }
        
        let mCoinSound = Bundle.main.path(forResource: "Sounds/CoinSound", ofType: "wav")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mCoinSound!))
            mCoinSoundPool.append(newAudioPlayer)
            
            return newAudioPlayer
        } catch {
            print(error)
        }

        print("Returning Element 0 of Sound System Pool - Failed to create new sound!")
        
        return mCoinSoundPool[0]
    }
    
    func GetNextAvailableHitSound() -> AVAudioPlayer
    {
        for sound in mHitSoundPool
        {
            if !sound.isPlaying { return sound }
        }
        
        let mHitSound = Bundle.main.path(forResource: "Sounds/Hit", ofType: "wav")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mHitSound!))
            mHitSoundPool.append(newAudioPlayer)
            
            return newAudioPlayer
        } catch {
            print(error)
        }

        print("Returning Element 0 of Sound System Pool - Failed to create new sound!")
        
        return mHitSoundPool[0]
    }
    
    func GetNextAvailableDeathSound() -> AVAudioPlayer
    {
        for sound in mCellDeathSoundPool
        {
            if !sound.isPlaying { return sound }
        }
        
        let mDeathSound = Bundle.main.path(forResource: "Sounds/WhiteBloodCellDeath", ofType: "wav")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mDeathSound!))
            mCellDeathSoundPool.append(newAudioPlayer)
            
            return newAudioPlayer
        } catch {
            print(error)
        }

        print("Returning Element 0 of Sound System Pool - Failed to create new sound!")
        
        return mCellDeathSoundPool[0]
    }
    
    
    //------------------------------------------------------------//
    //-------------------- System Functionality ------------------//
    //------------------------------------------------------------//
    
    func PlaySound(sound Sound: String)
    {
        if !defaults.bool(forKey: "AudioToggleValue") { return }
        
        if mSoundDict[Sound] != nil
        {
            mSoundDict[Sound]?.play()
        }
    }
    
    func PlaySoundOverlap(sound Sound: String)
    {
        if !defaults.bool(forKey: "AudioToggleValue") { return }
    
        /*
         var mProjectileShotPool : [AVAudioPlayer] = []
         var mCoinSoundPool : [AVAudioPlayer] = []
         var mHitSoundPool : [AVAudioPlayer] = []
         var mCellDeathSoundPool : [AVAudioPlayer] = []
         */
        
        if Sound == "Projectile Shot"
        {
            let soundToPlay = GetNextAvailableProjectileShotSound()
            soundToPlay.play()
        }
        else if Sound == "Coin"
        {
            let soundToPlay = GetNextAvailableCoinSound()
            soundToPlay.play()
        }
        else if Sound == "Hit"
        {
            let soundToPlay = GetNextAvailableHitSound()
            soundToPlay.play()
        }
        else if Sound == "Cell Death"
        {
            let soundToPlay = GetNextAvailableDeathSound()
            soundToPlay.play()
        }
        else
        {
            print("Invalid Sound Name!")
        }
        
    }
    
}
