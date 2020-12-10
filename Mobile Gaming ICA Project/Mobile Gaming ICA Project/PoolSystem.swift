//
//  PoolSystem.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 01/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class PoolSystem
{
    
    var mGameScene : GameScene!
    
    var mEnergyBallPool : [EnergyBall] = []
    var mWhiteBloodCellPool : [WhiteBloodCell] = []
    var mProjectileOnePool : [Projectile] = []
    var mProjectileTwoPool : [Projectile] = []
    var mProjectileThreePool : [Projectile] = []
    
    var UniqueIDs = 0
    
    //Pool Functionality
    func SetupPoolSystem(scene Scene: GameScene)
    {
        self.mGameScene = Scene
        
        for _ in 1...20
        {
            let newEnergyBall = EnergyBall(imageNamed: "Assets/Energy/BasicFood")
            newEnergyBall.InitialiseEnergyBall(scene: self.mGameScene)
            newEnergyBall.SetUniqueID(to: UniqueIDs)
            self.mEnergyBallPool.append(newEnergyBall)
            UniqueIDs = UniqueIDs + 1
        }
        
        for _ in 1...10
        {
            let newWhiteBloodCell = WhiteBloodCell(back: "Assets/Viruses/WhiteBloodCell-0000-SpikesOnly", front: "Assets/Viruses/WhiteBloodCell-0000-BodyOnly", speed: Float(1), id: UniqueIDs)
            newWhiteBloodCell.InitialiseWhiteBloodCell(scene: Scene, name: "WhiteBloodCell", zposition: 7)
            self.mWhiteBloodCellPool.append(newWhiteBloodCell)
            UniqueIDs = UniqueIDs + 1
        }
        
        for _ in 1...10
        {
            let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0000")
            newProjectile.InitialiseProjectile(scene: self.mGameScene)
            self.mProjectileOnePool.append(newProjectile)
        }
        
        for _ in 1...10
        {
            let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0001")
            newProjectile.InitialiseProjectile(scene: self.mGameScene)
            self.mProjectileTwoPool.append(newProjectile)
        }
        
        for _ in 1...10
        {
            let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0002")
            newProjectile.InitialiseProjectile(scene: self.mGameScene)
            self.mProjectileThreePool.append(newProjectile)
        }
    }
    
    func ReInitialise()
    {
        for ball in self.mEnergyBallPool
        {
            ball.InitialiseEnergyBall(scene: self.mGameScene)
        }
        
        for cell in self.mWhiteBloodCellPool
        {
            cell.InitialiseWhiteBloodCell(scene: self.mGameScene, name: "WhiteBloodCell", zposition: 7)
        }
        
        for projectile in self.mProjectileOnePool
        {
            projectile.InitialiseProjectile(scene: self.mGameScene)
        }
        
        for projectile in self.mProjectileTwoPool
        {
            projectile.InitialiseProjectile(scene: self.mGameScene)
        }
        
        for projectile in self.mProjectileThreePool
        {
            projectile.InitialiseProjectile(scene: self.mGameScene)
        }
    }
    
    func ResetPools()
    {
        
        for ball in self.mEnergyBallPool
        {
            ball.Consume()
        }
        
        for cell in self.mWhiteBloodCellPool
        {
            cell.DestroyWhiteBloodCell(playSound: false)
        }
        
        for projectile in self.mProjectileOnePool
        {
            projectile.DeactivateProjectile()
        }
        
        for projectile in self.mProjectileTwoPool
        {
            projectile.DeactivateProjectile()
        }
        
        for projectile in self.mProjectileThreePool
        {
            projectile.DeactivateProjectile()
        }
    }
    
    
    //Getting Next Available Entity
    func GetNextAvailableEnergyBall() -> EnergyBall
    {
        for ball in self.mEnergyBallPool
        {
            if !ball.GetAlive()
            {
                return ball
            }
        }
        
        let newEnergyBall = EnergyBall(imageNamed: "Assets/Energy/BasicFood")
        newEnergyBall.InitialiseEnergyBall(scene: self.mGameScene)
        newEnergyBall.SetUniqueID(to: UniqueIDs)
        self.mEnergyBallPool.append(newEnergyBall)
        UniqueIDs = UniqueIDs + 1
        
        return newEnergyBall
        
    }
    
    func GetNextAvailableWhiteBloodCell() -> WhiteBloodCell
    {
        for cell in self.mWhiteBloodCellPool
        {
            if !cell.GetAlive()
            {
                return cell
            }
        }
        
        let newWhiteBloodCell = WhiteBloodCell(back: "Assets/Viruses/WhiteBloodCell-0000-SpikesOnly", front: "Assets/Viruses/WhiteBloodCell-0000-BodyOnly", speed: Float(1), id: UniqueIDs)
        newWhiteBloodCell.InitialiseWhiteBloodCell(scene: self.mGameScene, name: "WhiteBloodCell", zposition: 7)
        self.mWhiteBloodCellPool.append(newWhiteBloodCell)
        UniqueIDs = UniqueIDs + 1
        
        return newWhiteBloodCell
    }
    
    func GetNextAvailableProjectileOne() -> Projectile
    {
        for projectile in self.mProjectileOnePool
        {
            if !projectile.GetAlive()
            {
                return projectile
            }
        }
        
        let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0000")
        newProjectile.InitialiseProjectile(scene: self.mGameScene)
        self.mProjectileOnePool.append(newProjectile)
        
        return newProjectile
    }
    
    func GetNextAvailableProjectileTwo() -> Projectile
    {
        for projectile in self.mProjectileTwoPool
        {
            if !projectile.GetAlive()
            {
                return projectile
            }
        }
        
        let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0001")
        newProjectile.InitialiseProjectile(scene: self.mGameScene)
        self.mProjectileTwoPool.append(newProjectile)
        
        return newProjectile
    }
    
    func GetNextAvailableProjectileThree() -> Projectile
    {
        for projectile in self.mProjectileThreePool
        {
            if !projectile.GetAlive()
            {
                return projectile
            }
        }
        
        let newProjectile = Projectile(imageNamed: "Assets/Projectiles/Projectile-0002")
        newProjectile.InitialiseProjectile(scene: self.mGameScene)
        self.mProjectileThreePool.append(newProjectile)
        
        return newProjectile
    }
    
    
    
    /*
     var mEnergyBallPool : [EnergyBall] = []
     var mWhiteBloodCellPool : [WhiteBloodCell] = []
    */
    
    //Returning Pool Arrays
    func GetEnergyBalls() -> [EnergyBall]
    {
        return self.mEnergyBallPool
    }
    
    func GetWhiteBloodCells() -> [WhiteBloodCell]
    {
        return self.mWhiteBloodCellPool
    }
    
    func GetProjectileOnePool() -> [Projectile]
    {
        return self.mProjectileOnePool
    }
    
    func GetProjectileTwoPool() -> [Projectile]
    {
        return self.mProjectileTwoPool
    }
    
    func GetProjectileThreePool() -> [Projectile]
    {
        return self.mProjectileThreePool
    }
    
    //Alive Counts
    func GetNumberOfEnergyBallsAlive() -> Int
    {
        var AliveCount = 0
        for EnergyBallInstance in GetEnergyBalls()
        {
            if EnergyBallInstance.GetAlive()
            {
                AliveCount = AliveCount + 1
            }
        }
        
        return AliveCount
    }
    
    func GetNumberOfWhiteBloodCellsAlive() -> Int
    {
        var AliveCount = 0
        for Cell in GetWhiteBloodCells()
        {
            if Cell.GetAlive()
            {
                AliveCount = AliveCount + 1
            }
        }
        
        return AliveCount
    }
}
