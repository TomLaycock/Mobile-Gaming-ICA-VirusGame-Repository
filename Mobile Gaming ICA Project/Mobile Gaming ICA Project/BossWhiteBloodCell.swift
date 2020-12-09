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

class BossWhiteBloodCell : WhiteBloodCell
{

    let mBossHealthBar = NumberBar(Start: 50, Max: 50, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/GreenSquare", Lentgh: 100, Height: 17)

    var mBossMaxHealth = CGFloat(50)
    var mBossHealth = CGFloat(50)
    {
        didSet
        {
            mBossHealthBar.SetNumberBarValue(to: Int(mBossHealth))
        }
    }
    
    override init(back BackTex: String, front FrontTex: String, speed Speed: Float, id UniqueID: Int) {
        super.init(back: BackTex, front: FrontTex, speed: Speed, id: UniqueID)
        super.mAlive = false
    }
    
    func InitialiseBossWhiteBloodCell(scene Scene: GameScene, name Name: String, zposition ZPosition: CGFloat)
    {
        mBossMaxHealth = 50
        mBossHealth = mBossMaxHealth
        
        super.mAlive = false
        InitialiseWhiteBloodCell(scene: Scene, name: Name, zposition: ZPosition)
        
        mBossHealthBar.SetBarPosition(to: super.GetPosition())
        mBossHealthBar.SetBarZPosition(to: 90)
        
        Scene.addChild(mBossHealthBar.GetBarBackground())
        Scene.addChild(mBossHealthBar.GetBarForeground())
        Scene.addChild(mBossHealthBar.GetBarText())
    }
    
    func UpdateHealthBarPosition()
    {
        let SpriteHeight = super.mCellBackground.size.height
        mBossHealthBar.SetBarPosition(to: super.GetPosition() + CGPoint(x: 0, y: (SpriteHeight / 2)))
    }
    
    override func Update(rotationSpeed Speed: Float)
    {
        RotateBackground(rotationSpeed: Speed)
        UpdateHealthBarPosition()
    }
    
}

//Health Extension
extension BossWhiteBloodCell
{
    func SetMaxHealth(to Value: CGFloat)
    {
        self.mBossMaxHealth = Value
    }
    
    func GetMaxHealth() -> CGFloat
    {
        return self.mBossMaxHealth
    }
    
    func SetHealth(to Value: CGFloat)
    {
        self.mBossHealth = Value
        self.CheckHealthBounds()
    }
    
    func GetHealth() -> CGFloat
    {
        return self.mBossHealth
    }
    
    func IncreaseHealth(by Value: CGFloat)
    {
        self.mBossHealth = self.mBossHealth + Value
        self.CheckHealthBounds()
    }
    
    func DecreaseHealth(by Value: CGFloat)
    {
        self.mBossHealth = self.mBossHealth - Value
        self.CheckHealthBounds()
    }
    
    func CheckHealthBounds()
    {
        if self.mBossHealth > self.mBossMaxHealth
        {
            self.mBossHealth = self.mBossMaxHealth
        }
        if self.mBossHealth < 0
        {
            self.mBossHealth = 0
        }
    }
}
