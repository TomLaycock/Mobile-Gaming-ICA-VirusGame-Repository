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
    
    //Projectile Values
    var mDamage = 0
    var mMovementDirection = Vector2(x: 0, y: 0)
    var mSpeed = CGFloat(1)

    //Initialising the Projectile
    func InitialiseProjectile(scene Scene: GameScene)
    {
        self.mGameScene = Scene //Storing the GameScnee
        
        //Setting Projectile intiail Values
        self.name = "Projectile"
        self.position = CGPoint(x: -100, y: 0)
        self.size = CGSize(width: 20, height: 20)
        
        self.mAlive = false
        
        //Adding projectile to Scene Children
        self.mGameScene.addChild(self)
    }
    
    func Spawn(at Pos: CGPoint, dir Dir: Vector2, with Damage: Int, speed Speed: CGFloat) // Spawns projectile with direction, speed and damage
    {
        self.position = Pos
        self.mMovementDirection = Dir
        self.mSpeed = Speed
        self.mDamage = Damage
        self.mAlive = true //Sets projectile to alive
    }
    
    func DeactivateProjectile() //Deactivates the projectile
    {
        //Creates a Projectile Explosion
        if let mProjectileExplosion = SKEmitterNode(fileNamed: "ProjectileExplosion")
        {
            mProjectileExplosion.position = CGPoint(x: self.position.x, y: self.position.y)
            mGameScene.addChild(mProjectileExplosion)

            //Removes after 0.5 seconds
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()])
            mProjectileExplosion.run(removeAfterDead)
        }
        
        //Resets position and alive value
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
    
    //Checks for projectile collisions with White blood cells
    func CheckCollisionWithWhiteBloodCells(cells Cells: [WhiteBloodCell])
    {
        for cell in Cells
        {
            if !cell.GetAlive() { continue }
            
            //Distance check from projectile center to White Blood Cell Center
            if Vector2.magnitude(v: Vector2(CGPoint: cell.GetPosition()) - Vector2(CGPoint: self.position)) < cell.mCellBackground.size.width / 2
            {
                mGameScene.mSoundSystem.PlaySound(sound: "Hit", scene: mGameScene) //Plays hit Sound
                self.mGameScene.mScore = self.mGameScene.mScore + 5
                self.DeactivateProjectile()
                
                mGameScene.mPlayer.IncreaseEnergy(by: CGFloat(5))
                cell.DestroyWhiteBloodCell(playSound: true)
            }
        }
    }
    
    //Boss Collision Checks
    func CheckCollisionWithBoss(cell Cell: BossWhiteBloodCell)
    {
        if !Cell.GetAlive() { return }
        
        //Distance check from projectile center to White Blood Cell Center
        if Vector2.magnitude(v: Vector2(CGPoint: Cell.GetPosition()) - Vector2(CGPoint: self.position)) < Cell.mCellBackground.size.width / 2
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Hit", scene: mGameScene) //Plays hit sound
            self.DeactivateProjectile()
            
            mGameScene.mPlayer.IncreaseEnergy(by: CGFloat(1))
            Cell.DecreaseHealth(by: CGFloat(self.mDamage))
        }
    }
    
    //Moves the projectile in the specified direction using the Speed Value and the Game Delta Time
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
    
    //Checks if the projectile is outside of the screen bounds
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
            DeactivateProjectile() //Kills projectile if outside of screen
        }
    }
    
}
