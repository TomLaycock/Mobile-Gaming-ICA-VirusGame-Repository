//
//  Button.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by LAYCOCK, TOM (Student) on 29/11/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Button: SKSpriteNode {
    
    var mButtonPosition = CGPoint(x: -100, y: 0)
    
    func SetButtonPosition(to position: CGPoint)
    {
        mButtonPosition = position
    }
    
    func SetButtonState(value Toggle: Bool)
    {
        if Toggle
        {
            self.position = mButtonPosition
        }
        else
        {
            self.position = CGPoint(x: -100, y: 0)
        }
    }
}
