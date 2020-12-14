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

class Projectile : SKSpriteNode {

    var mGameScene : GameScene!
    
    var mAlive = false
    
    var mDamage = 0
    var mMovementDirection = Vector2(x: 0, y: 0)
    var mSpeed = CGFloat(1)

    func InitialiseProjectile(scene Scene: GameScene)
    {
        self.mGameScene = Scene
        
        self.name = "Projectile"
        self.position = CGPoint(x: -100, y: 0)
        self.size = CGSize(width: 20, height: 20)
        
        self.mAlive = false
        
        self.mGameScene.addChild(self)
    }
    
    func Spawn(at Pos: CGPoint, dir Dir: Vector2, with Damage: Int, speed Speed: CGFloat)
    {
        self.position = Pos
        self.mMovementDirection = Dir
        self.mSpeed = Speed
        self.mDamage = Damage
        self.mAlive = true
    }
    
    func DeactivateProjectile()
    {
        if let mProjectileExplosion = SKEmitterNode(fileNamed: "ProjectileExplosion")
        {
            mProjectileExplosion.position = CGPoint(x: self.position.x, y: self.position.y)
            mGameScene.addChild(mProjectileExplosion)

            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()])
            mProjectileExplosion.run(removeAfterDead)
        }
        
        self.position = CGPoint(x: -100, y: 0)
        self.mAlive = false
    }
    
    func GetDamage() -> Int
    {
        return self.mDamage
    }
    
    func GetAlive() -> Bool
    {
        return self.mAlive
    }
    
    func SetSpeed(to Value: CGFloat)
    {
        self.mSpeed = Value
    }
    
    func CheckCollisionWithWhiteBloodCells(cells Cells: [WhiteBloodCell])
    {
        for cell in Cells
        {
            if !cell.GetAlive() { continue }
            
            if Vector2.magnitude(v: Vector2(CGPoint: cell.GetPosition()) - Vector2(CGPoint: self.position)) < cell.mCellBackground.size.width / 2
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Hit", scene: mGameScene)
                self.mGameScene.mScore = self.mGameScene.mScore + 5
                self.DeactivateProjectile()
                
                mGameScene.mPlayer.IncreaseEnergy(by: CGFloat(5))
                cell.DestroyWhiteBloodCell(playSound: true)
            }
        }
    }
    
    func CheckCollisionWithBoss(cell Cell: BossWhiteBloodCell)
    {
        if !Cell.GetAlive() { return }
        if Vector2.magnitude(v: Vector2(CGPoint: Cell.GetPosition()) - Vector2(CGPoint: self.position)) < Cell.mCellBackground.size.width / 2
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Hit", scene: mGameScene)
            self.DeactivateProjectile()
            
            mGameScene.mPlayer.IncreaseEnergy(by: CGFloat(1))
            Cell.DecreaseHealth(by: CGFloat(self.mDamage))
        }
    }
    
    func MoveProjectile()
    {
        let CurrentPos = self.position
        
        let DeltaTime = Float(self.mGameScene.GetDeltaTime())
        
        let newPos = CGPoint(x:
        CurrentPos.x + CGFloat((mMovementDirection.x * DeltaTime)) * self.mSpeed,
                         y:
        CurrentPos.y + CGFloat((mMovementDirection.y * DeltaTime)) * self.mSpeed
                         )
        
        self.position = newPos
    }
    
    func CheckOutOfScreenBounds() -> Bool
    {
        if self.position.x > mGameScene.frame.maxX + self.size.width
        {
            return true
        }
        if self.position.x < -self.size.width
        {
            return true
        }
        if self.position.y > mGameScene.frame.maxY + self.size.width
        {
            return true
        }
        if self.position.y < -self.size.width
        {
            return true
        }
        return false
    }
    
    func Update()
    {
        MoveProjectile()
        if CheckOutOfScreenBounds()
        {
            DeactivateProjectile()
        }
    }
    
}
