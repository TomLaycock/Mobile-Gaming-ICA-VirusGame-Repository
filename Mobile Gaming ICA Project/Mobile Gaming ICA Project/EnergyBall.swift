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

    var mGameScene : GameScene!
    
    var mEnergyToProvide = 0
    var mAlive = false
    var mUniqueID = -1
    
    func CheckCollisionWithOtherEnergyCells(otherCells Cells: [EnergyBall]) -> Bool
    {
        for EnergyBallInstance in Cells
        {
            if EnergyBallInstance.mUniqueID == self.mUniqueID { continue }
            if EnergyBallInstance.GetAlive()
            {
                if Vector2.magnitude(v: Vector2(CGPoint: EnergyBallInstance.position) - Vector2(CGPoint: self.position)) < (EnergyBallInstance.size.width / 2) + (self.size.width / 2)
                {
                    return true
                }
            }
        }
        return false
    }
    
    func SetUniqueID(to Value: Int)
    {
        self.mUniqueID = Value
    }
    
    func Spawn(with Energy: Int, otherCells Cells: [EnergyBall])
    {
        
        var newPos = CGPoint(x: Int.random(in: 10...Int(mGameScene.frame.maxX - 10)), y: Int.random(in: 10...Int(mGameScene.frame.maxY - 10)))
        
        while CheckCollisionWithOtherEnergyCells(otherCells: Cells) {
            newPos = CGPoint(x: Int.random(in: 10...Int(mGameScene.frame.maxX - 10)), y: Int.random(in: 10...Int(mGameScene.frame.maxY - 10)))
        }
        
        self.position = newPos
        
        self.name = "EnergyBall"
        self.size = CGSize(width: CGFloat(Energy * 10), height: CGFloat(Energy * 10))
        self.zPosition = 5
        self.mEnergyToProvide = Energy
        self.mAlive = true
    }
    
    func InitialiseEnergyBall(scene Scene: GameScene)
    {
        self.mGameScene = Scene
        
        self.name = "EnergyBall"
        self.position = CGPoint(x: -100, y: 0)
        self.size = CGSize(width: 1, height: 1)
        self.mAlive = false
        
        Scene.addChild(self)
    }
    
    func Consume()
    {
        if let mCollectParticle = SKEmitterNode(fileNamed: "CollectParticle")
        {
            mCollectParticle.position = CGPoint(x: self.position.x, y: self.position.y)
            mGameScene.addChild(mCollectParticle)

            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()])
            mCollectParticle.run(removeAfterDead)
        }
        
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
    
    func CheckCollisionWithPlayer(player Player: Player)
    {
        if Vector2.magnitude(v: Vector2(CGPoint: Player.GetPosition()) - Vector2(CGPoint: self.position)) < Player.mCellBackground.size.width / 2
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Small Click", scene: mGameScene)
            self.mGameScene.mScore = self.mGameScene.mScore + self.GetEnergyToProvide()
            self.Consume()
            
            Player.IncreaseEnergy(by: CGFloat(self.GetEnergyToProvide()))
        }
    }
    
}
