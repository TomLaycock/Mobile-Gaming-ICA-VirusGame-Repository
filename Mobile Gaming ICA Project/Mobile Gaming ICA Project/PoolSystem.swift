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
    
    
    //Pool Functionality
    func SetupPoolSystem(scene Scene: GameScene)
    {
        self.mGameScene = Scene
        
        for _ in 1...20
        {
            let newEnergyBall = EnergyBall(imageNamed: "Assets/Energy/BasicFood")
            newEnergyBall.InitialiseEnergyBall(scene: self.mGameScene)
            self.mEnergyBallPool.append(newEnergyBall)
        }
        
        for _ in 1...10
        {
            let newWhiteBloodCell = WhiteBloodCell(back: "Assets/Viruses/WhiteBloodCell-0000-SpikesOnly", front: "Assets/Viruses/WhiteBloodCell-0000-BodyOnly", speed: Float(1))
            newWhiteBloodCell.InitialiseWhiteBloodCell(scene: Scene, name: "WhiteBloodCell", zposition: 7)
            self.mWhiteBloodCellPool.append(newWhiteBloodCell)
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
        self.mEnergyBallPool.append(newEnergyBall)
        
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
        
        let newWhiteBloodCell = WhiteBloodCell(back: "Assets/Viruses/WhiteBloodCell-0000-SpikesOnly", front: "Assets/Viruses/WhiteBloodCell-0000-BodyOnly", speed: Float(1))
        newWhiteBloodCell.InitialiseWhiteBloodCell(scene: self.mGameScene, name: "WhiteBloodCell", zposition: 7)
        self.mWhiteBloodCellPool.append(newWhiteBloodCell)
        
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
}
