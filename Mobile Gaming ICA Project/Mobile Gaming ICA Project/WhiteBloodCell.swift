//
//  WhiteBloodCell.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 01/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class WhiteBloodCell : Cell
{

    var mGameScene : GameScene!
    
    var mAlive = false
    var mSpeed = Float(1)
    var mUniqueID = -1

    private var mRotationCounter = Float(0)
    
    init(back BackTex: String, front FrontTex: String, speed Speed: Float, id UniqueID: Int) {
        
        self.mAlive = false
        self.mSpeed = Speed
        self.mUniqueID = UniqueID
        
        //Initialise Cell
        super.init(back: BackTex, front: FrontTex)
    }
    
    func InitialiseWhiteBloodCell(scene Scene: GameScene, name Name: String, zposition ZPosition: CGFloat)
    {
        self.mAlive = false
        self.mGameScene = Scene
        
        //Initialise Cell Function
        super.InitialiseCell(scene: Scene, name: Name, zposition: ZPosition)
    }
    
    func CheckCollisionWithOtherCells(otherCells Cells: [WhiteBloodCell]) -> Bool
    {
        for Cell in Cells
        {
            if Cell.mUniqueID == self.mUniqueID { continue }
            if Cell.GetAlive()
            {
                if Vector2.magnitude(v: Vector2(CGPoint: Cell.GetPosition()) - Vector2(CGPoint: self.GetPosition())) < (Cell.mCellBackground.size.width / 2) + (self.mCellBackground.size.width / 2)
                {
                    return true
                }
            }
        }
        return false
    }
    
    func SpawnWhiteBloodCell(size Size: CGSize, otherCells Cells: [WhiteBloodCell])
    {
        self.mAlive = true
        let CellHalfWidth = Int(self.mCellBackground.size.width / 2)
        let ScreenWidth = Int(mGameScene.frame.maxX)
        let ScreenHeight = Int(mGameScene.frame.maxY)
        
        let RandAxis = Int.random(in: 0...1)
        
        var newPos = CGPoint(x: 0, y: 0)

        if RandAxis == 0
        {
            let randomSide = Int.random(in: 0...1)
            newPos = CGPoint(x: -CellHalfWidth + (randomSide * (ScreenWidth + CellHalfWidth)), y: Int.random(in: CellHalfWidth...Int(ScreenHeight - CellHalfWidth)))
            
            while CheckCollisionWithOtherCells(otherCells: Cells) {
                newPos = CGPoint(x: -CellHalfWidth + (randomSide * (ScreenWidth + CellHalfWidth)), y: Int.random(in: CellHalfWidth...Int(ScreenHeight - CellHalfWidth)))
            }
        }
        else
        {
            let randomSide = Int.random(in: 0...1)
            newPos = CGPoint(x: Int.random(in: CellHalfWidth...Int(ScreenWidth - CellHalfWidth)), y: -CellHalfWidth + (randomSide * (ScreenHeight + CellHalfWidth)))
            
            while CheckCollisionWithOtherCells(otherCells: Cells) {
                newPos = CGPoint(x: Int.random(in: CellHalfWidth...Int(ScreenWidth - CellHalfWidth)), y: Int.random(in: CellHalfWidth...Int(ScreenHeight - CellHalfWidth)))
            }
        }
        
        super.SetPosition(to: newPos)
        super.SetSize(to: Size)
    }
    
    func DestroyWhiteBloodCell(playSound PlaySound: Bool)
    {
        if PlaySound
        {
            mGameScene.mSoundSystem.PlaySound(sound: "Cell Death", scene: mGameScene)
        }

        if let mDestroyParticle = SKEmitterNode(fileNamed: "BasicExplosion")
        {
            mDestroyParticle.position = CGPoint(x: self.GetPosition().x, y: self.GetPosition().y)
            mGameScene.addChild(mDestroyParticle)

            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
            mDestroyParticle.run(removeAfterDead)
        }
        
        self.mAlive = false
        super.SetPosition(to: CGPoint(x: -1000, y: -1000))
        
        mGameScene.mNumberOfWhiteBloodCellsKilled = mGameScene.mNumberOfWhiteBloodCellsKilled + 1
    }
    
    func GetAlive() -> Bool
    {
        return mAlive
    }
    
    func SetSpeed(to Speed: Float)
    {
        mSpeed = Speed
    }
        
    func MoveBy(by Position: Vector2)
    {
        let currentPos = super.GetPosition()
        let newPos = CGPoint(x:
            currentPos.x + CGFloat((Position.x * self.mSpeed) * Float(self.mGameScene.GetDeltaTime())),
                             y:
            currentPos.y + CGFloat((Position.y * self.mSpeed) * Float(self.mGameScene.GetDeltaTime()))
                             )
        
        super.SetPosition(to: newPos)
    }
    
    func MoveTowards(target Target: CGPoint)
    {
        let CurrentPos = super.GetPosition()
        let Direction = Vector2(CGPoint: Target) - Vector2(CGPoint: CurrentPos)
        let NDir = Vector2.normalise(v: Direction)
        
        let DeltaTime = Float(self.mGameScene.GetDeltaTime())
        
        let newPos = CGPoint(x:
        CurrentPos.x + CGFloat((NDir.x * DeltaTime) * self.mSpeed),
                         y:
        CurrentPos.y + CGFloat((NDir.y * DeltaTime) * self.mSpeed)
                         )
        
        if Vector2.magnitude(v: Vector2(x: (NDir.x * DeltaTime) * self.mSpeed, y: (NDir.y * DeltaTime) * self.mSpeed)) > Vector2.magnitude(v: Direction)
        {
            return
        }
        
        /*for Cell in mGameScene.mPoolSystem.GetWhiteBloodCells()
        {
            if Cell.mUniqueID == self.mUniqueID { continue }
            if Cell.GetAlive()
            {
                let TotalCellWidth = (Cell.mCellBackground.size.width / 2) + (self.mCellBackground.size.width / 2) - 20
                //let DistanceBetweenCells = Vector2.magnitude(v: Vector2(CGPoint: Cell.GetPosition()) - Vector2(CGPoint: self.GetPosition())) - TotalCellWidth
                if Vector2.magnitude(v: Vector2(CGPoint: Cell.GetPosition()) - Vector2(CGPoint: newPos)) < TotalCellWidth
                {
                    return
                }
            }
        }*/

        super.SetPosition(to: newPos)
    }
 
    func CheckCollisionWithPlayer(player Player: Player)
    {
        if Vector2.magnitude(v: Vector2(CGPoint: Player.GetPosition()) - Vector2(CGPoint: self.GetPosition())) < Player.mCellBackground.size.width / 2
        {
            Player.DecreaseHealth(by: CGFloat(5))
            self.DestroyWhiteBloodCell(playSound: true)
        }
    }
    
    func RotateBackground(rotationSpeed Speed: Float)
    {
        let DeltaTime = Float(mGameScene.GetDeltaTime())
        mCellBackground.zRotation = CGFloat(mRotationCounter)
        mRotationCounter = Float(mRotationCounter) + (Speed * DeltaTime)
    }
    
    func Update(rotationSpeed Speed: Float)
    {
        RotateBackground(rotationSpeed: Speed)
    }
    
}
