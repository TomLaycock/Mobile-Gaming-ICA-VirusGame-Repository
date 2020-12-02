//
//  EnergyBall.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 01/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class EnergyBall : SKSpriteNode {

    var mEnergyToProvide = 0
    var mAlive = false
    
    func Spawn(at Position: CGPoint, with Energy: Int)
    {
        self.name = "EnergyBall"
        self.position = Position
        self.size = CGSize(width: CGFloat(Energy * 10), height: CGFloat(Energy * 10))
        self.zPosition = 5
        self.mEnergyToProvide = Energy
        self.mAlive = true
    }
    
    func InitialiseEnergyBall(scene Scene: GameScene)
    {
        self.name = "EnergyBall"
        self.position = CGPoint(x: -100, y: 0)
        self.size = CGSize(width: 1, height: 1)
        self.mAlive = false
        
        Scene.addChild(self)
    }
    
    func Consume()
    {
        self.position = CGPoint(x: -100, y: 0)
        self.mAlive = false
    }
    
    func GetEnergyToProvide() -> Int
    {
        return self.mEnergyToProvide
    }
    
    func GetAlive() -> Bool
    {
        return self.mAlive
    }
    
}
