//
//  Player.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 02/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Player : Cell
{
    
    var mGameScene : GameScene!
    
    var mAlive = false
    var mSpeed = Float(1)
    
    var mHealth = CGFloat(100)
    {
        didSet
        {
            self.mGameScene.mHealthBar.SetNumberBarValue(to: Int(self.mHealth))
        }
    }
    
    var mMaxHealth = CGFloat(100)
    {
        didSet
        {
            self.mGameScene.mHealthBar.SetNumberBarMax(to: Int(self.mMaxHealth))
        }
    }
    
    var mEnergy = CGFloat(0)
    {
        didSet
        {
            self.mGameScene.mEnergyBar.SetNumberBarValue(to: Int(self.mEnergy))
        }
    }
    
    var mMaxEnergy = CGFloat(100)
    {
        didSet
        {
            self.mGameScene.mEnergyBar.SetNumberBarMax(to: Int(self.mMaxEnergy))
        }
    }
    
    var mMovementDirection : Vector2!
    
    private var mRotationCounter = Float(0)
    
    init(back BackTex: String, front FrontTex: String, speed Speed: Float) {
        
        self.mAlive = false
        self.mSpeed = Speed
        
        self.mMovementDirection = Vector2(x: 0, y: 0)
        
        //Initialise Cell
        super.init(back: BackTex, front: FrontTex)
    }
    
    func InitialisePlayer(scene Scene: GameScene, name Name: String, zposition ZPosition: CGFloat)
    {
        self.mAlive = false
        self.mGameScene = Scene
        
        self.mMovementDirection = Vector2(x: 0, y: 0)
        
        self.mMaxHealth = 100
        self.mHealth = self.mMaxHealth
        
        self.mMaxEnergy = 100
        self.mEnergy = 0
        
        //Initialise Cell Function
        super.InitialiseCell(scene: Scene, name: Name, zposition: ZPosition)
    }
    
    func SpawnPlayer(position Position: CGPoint, size Size: CGSize)
    {
        super.SetPosition(to: Position)
        super.SetSize(to: Size)
        
        self.mMovementDirection = Vector2(x: 0, y: 0)
        
        self.mAlive = true
    }
    
    func DestroyPlayer()
    {
        self.mAlive = false
        super.SetPosition(to: CGPoint(x: -100, y: 0))
    }
    
    func GetAlive() -> Bool
    {
        return mAlive
    }
    
    func SetSpeed(to Speed: Float)
    {
        self.mSpeed = Speed
    }

    func UpdateMovementDirection(rotation rotVector: Vector2, acceleration accVector: Vector2)
    {
        //var newVecNorm = Vector2(x: 0, y: 0)
        
        /*if !(Vector.x == 0 && Vector.y == 0)
        {
            newVecNorm = Vector2.normalise(v: Vector)
        }*/

        if Vector2.magnitude(v: accVector) <= 0.1
        {
            return
        }
        
        self.mMovementDirection = Vector2(x: 0, y: 0)
        
        self.mMovementDirection = Vector2(x: self.mMovementDirection.x + accVector.x, y: self.mMovementDirection.y + accVector.y)
        
        if Vector2.magnitude(v: self.mMovementDirection) < 0.1
        {
            self.mMovementDirection = Vector2(x: 0, y: 0)
        }
        
        /*if !(self.mMovementDirection.x == 0 && self.mMovementDirection.y == 0)
        {
            mMovementDirection = Vector2.normalise(v: mMovementDirection)
        }*/
    }
    
    func LockToScreenBounds(pos Position: inout CGPoint)
    {
        let minXBound = 0 + (self.mCellBackground.size.width / 2)
        let maxXBound = self.mGameScene.frame.maxX - (self.mCellBackground.size.width / 2)
        
        let minYBound = 0 + (self.mCellBackground.size.width / 2)
        let maxYBound = self.mGameScene.frame.maxY - (self.mCellBackground.size.height / 2)
        
        if Position.x > maxXBound
        {
            Position.x = maxXBound
        }
        
        if Position.x < minXBound
        {
            Position.x = minXBound
        }
        
        if Position.y > maxYBound
        {
            Position.y = maxYBound
        }
        
        if Position.y < minYBound
        {
            Position.y = minYBound
        }
    }
    
    func MovePlayer()
    {
        let DeltaTime = Float(self.mGameScene.GetDeltaTime())
        
        var newMovementDirection = Vector2(x: self.mMovementDirection.x, y: self.mMovementDirection.y)

        if !(newMovementDirection.x == 0 && newMovementDirection.y == 0)
        {
            newMovementDirection = Vector2.normalise(v: newMovementDirection)
        }
        
        //print(self.mMovementDirection.x)
        //print(self.mMovementDirection.y)
        
        let newX = super.GetPosition().x + CGFloat((newMovementDirection.x * DeltaTime) * self.mSpeed)
        let newY = super.GetPosition().y + CGFloat((newMovementDirection.y * DeltaTime) * self.mSpeed)
        
        //print(String(Double(newX)) + "     " + String(Double(newY)) + "     " + String(Double(DeltaTime)))
        
        var newPos = CGPoint(x: newX, y: newY)
        
        //print("Before")
        //print(newPos)
        
        LockToScreenBounds(pos: &newPos)
        
        //print("After")
        //print(newPos)
        
        super.SetPosition(to: newPos)
    }
    
    func RotateBackground(speed Speed: CGFloat)
    {
        let DeltaTime = Float(mGameScene.GetDeltaTime())
        mCellBackground.zRotation = CGFloat(mRotationCounter)
        mRotationCounter = Float(mRotationCounter) + (Float(Speed) * DeltaTime)
    }
    
    func UpdatePlayer(speed Speed: CGFloat)
    {
        MovePlayer()
        RotateBackground(speed: Speed)
    }
    
}

//Energy Extension
extension Player
{
    func SetEnergy(to Value: CGFloat)
    {
        self.mEnergy = Value
        self.CheckEnergyBounds()
    }
    
    func SetMaxEnergy(to Value: CGFloat)
    {
        self.mMaxEnergy = Value
    }
    
    func IncreaseEnergy(by Value: CGFloat)
    {
        self.mEnergy = self.mEnergy + Value
        self.CheckEnergyBounds()
    }
    
    func DecreaseEnergy(by Value: CGFloat)
    {
        self.mEnergy = self.mEnergy - Value
        self.CheckEnergyBounds()
    }
    
    func GetEnergy() -> CGFloat
    {
        return self.mEnergy
    }
    
    func GetMaxEnergy() -> CGFloat
    {
        return self.mMaxEnergy
    }
    
    func CheckEnergyBounds()
    {
        if self.mEnergy > self.mMaxEnergy
        {
            self.mEnergy = self.mMaxEnergy
        }
        if self.mEnergy < 0
        {
            self.mEnergy = 0
        }
    }
}

//Health Extension
extension Player
{
    func SetMaxHealth(to Value: CGFloat)
    {
        self.mMaxHealth = Value
    }
    
    func GetMaxHealth() -> CGFloat
    {
        return self.mMaxHealth
    }
    
    func SetHealth(to Value: CGFloat)
    {
        self.mHealth = Value
        self.CheckHealthBounds()
    }
    
    func GetHealth() -> CGFloat
    {
        return self.mHealth
    }
    
    func IncreaseHealth(by Value: CGFloat)
    {
        self.mHealth = self.mHealth + Value
        self.CheckHealthBounds()
    }
    
    func DecreaseHealth(by Value: CGFloat)
    {
        self.mHealth = self.mHealth - Value
        self.CheckHealthBounds()
    }
    
    func CheckHealthBounds()
    {
        if self.mHealth > self.mMaxHealth
        {
            self.mHealth = self.mMaxHealth
        }
        if self.mHealth < 0
        {
            self.mHealth = 0
        }
    }
}
