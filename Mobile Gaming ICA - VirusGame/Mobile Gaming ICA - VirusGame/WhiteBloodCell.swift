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

    init(back BackTex: String, front FrontTex: String, speed Speed: Float) {
        
        self.mAlive = false
        self.mSpeed = Speed
        
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
    
    func SpawnWhiteBloodCell(position Position: CGPoint, size Size: CGSize)
    {
        super.SetPosition(to: Position)
        super.SetSize(to: Size)
        self.mAlive = true
    }
    
    func DestroyWhiteBloodCell()
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
        
        super.SetPosition(to: newPos)
    }
    
}
