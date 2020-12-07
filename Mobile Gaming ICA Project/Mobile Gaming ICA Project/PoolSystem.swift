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
    }
    
    func ResetPools()
    {
        
        for ball in self.mEnergyBallPool
        {
            ball.Consume()
        }
        
        for cell in self.mWhiteBloodCellPool
        {
            cell.DestroyWhiteBloodCell()
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
