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
    
    //Energy Ball Values
    var mEnergyToProvide = 0
    var mAlive = false
    var mUniqueID = -1
    
    //Checks for collisions with other Energy balls to prevent spawning inside of another
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
    
    //Spawns energy ball with a specific amount of energy
    func Spawn(with Energy: Int, otherCells Cells: [EnergyBall])
    {
        
        let EnergySize = CGFloat(Energy) * (self.mGameScene.frame.maxY / 50)
        
        //Setting Energy Ball Defaults
        self.name = "EnergyBall"
        self.size = CGSize(width: EnergySize, height: EnergySize)
        self.zPosition = 5
        self.mEnergyToProvide = Energy
        self.mAlive = true
        
        var newPos = CGPoint(x: Int.random(in: 10...Int(mGameScene.frame.maxX - 10)), y: Int.random(in: 10...Int(mGameScene.frame.maxY - 10)))
        
        while CheckCollisionWithOtherEnergyCells(otherCells: Cells) {
            newPos = CGPoint(x: Int.random(in: 10...Int(mGameScene.frame.maxX - 10)), y: Int.random(in: 10...Int(mGameScene.frame.maxY - 10)))
        }
        
        self.position = newPos
    }
    
    //Initialising energy ball
    func InitialiseEnergyBall(scene Scene: GameScene)
    {
        self.mGameScene = Scene //Storing Game Scene
        
        self.name = "EnergyBall"
        self.position = CGPoint(x: -100, y: 0)
        self.size = CGSize(width: 1, height: 1)
        self.mAlive = false
        
        Scene.addChild(self)
    }
    
    //Consumes the Energy Ball resetting its values
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
    
    //Checks for collisions with player giving the player some score and some energy
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
