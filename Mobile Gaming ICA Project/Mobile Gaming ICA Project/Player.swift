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
    
    var mMovementDirection : Vector2!
    
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
    
    func UpdateMovementDirection(by Vector: Vector2)
    {
        var newVecNorm = Vector2(x: 0, y: 0)
        
        if !(Vector.x == 0 && Vector.y == 0)
        {
            newVecNorm = Vector2.normalise(v: Vector)
        }

        self.mMovementDirection = Vector2(x: self.mMovementDirection.x + newVecNorm.x, y: self.mMovementDirection.y + newVecNorm.y)

        if !(self.mMovementDirection.x == 0 && self.mMovementDirection.y == 0)
        {
            mMovementDirection = Vector2.normalise(v: mMovementDirection)
        }
    }
    
    func MovePlayer()
    {
        let DeltaTime = Float(self.mGameScene.GetDeltaTime())
        
        //print(String(Double(self.mMovementDirection.x)))
        
        let newX = super.GetPosition().x + CGFloat((self.mMovementDirection.x * DeltaTime) * self.mSpeed)
        let newY = super.GetPosition().y + CGFloat((self.mMovementDirection.y * DeltaTime) * self.mSpeed)
        
        //print(String(Double(newX)) + "     " + String(Double(newY)) + "     " + String(Double(DeltaTime)))
        
        let newPos = CGPoint(x: newX, y: newY)
        
        super.SetPosition(to: newPos)
    }
    
    func UpdatePlayer()
    {
        MovePlayer()
    }
    
}
