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

    //User Save Values
    let defaults = UserDefaults.standard
    
    func SetupCustomSoundSystem()
    {
        let sound1 = Bundle.main.path(forResource: "Sounds/ButtonClicks/Button-0000", ofType: "wav")
        do {
            mSoundDict["Button-0000"] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound1!))
        } catch {
            print(error)
        }
    }
    
    func PlaySound(sound Sound: String)
    {
        if !defaults.bool(forKey: "AudioToggleValue") { return }
        
        if mSoundDict[Sound] != nil
        {
            mSoundDict[Sound]?.play()
        }
    }
    
    func PlaySoundOverlap(sound SOund: String)
    {
        if !defaults.bool(forKey: "AudioToggleValue") { return }
    }
    
}
