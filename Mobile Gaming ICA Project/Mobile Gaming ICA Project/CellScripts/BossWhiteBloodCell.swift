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

    let mBossHealthBar = NumberBar(Start: 150, Max: 150, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/GreenSquare", Lentgh: 120, Height: 20)

    var mBossMaxHealth = CGFloat(150)
    var mBossHealth = CGFloat(150)
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
    
    override func CheckCollisionWithPlayer(player Player: Player)
    {
        if Vector2.magnitude(v: Vector2(CGPoint: Player.GetPosition()) - Vector2(CGPoint: self.GetPosition())) < Player.mCellBackground.size.width / 2
        {
            Player.DecreaseHealth(by: CGFloat(50))
            mGameScene.mSoundSystem.PlaySound(sound: "Hit", scene: mGameScene)
            if Player.GetHealth() > 0
            {
                self.SetPosition(to: CGPoint(x: mGameScene.frame.midX, y: mGameScene.frame.maxY + (self.mCellBackground.size.height / 2)))
            }
        }
    }
    
    //Initialising Boss White Blood Cell Default Values
    func InitialiseBossWhiteBloodCell(scene Scene: GameScene, name Name: String, zposition ZPosition: CGFloat)
    {
        mBossMaxHealth = 150
        mBossHealth = mBossMaxHealth
        
        super.mAlive = false
        InitialiseWhiteBloodCell(scene: Scene, name: Name, zposition: ZPosition)
        
        mBossHealthBar.SetBarPosition(to: super.GetPosition())
        mBossHealthBar.SetBarZPosition(to: 50)
        
        Scene.addChild(mBossHealthBar.GetBarBackground())
        Scene.addChild(mBossHealthBar.GetBarForeground())
        Scene.addChild(mBossHealthBar.GetBarText())
    }
    
    func UpdateHealthBarPosition()
    {
        let SpriteHeight = super.mCellBackground.size.height
        mBossHealthBar.SetBarPosition(to: super.GetPosition() + CGPoint(x: -(mBossHealthBar.GetBarBackground().size.width / 2), y: (SpriteHeight / 2)))
    }
    
    func CheckHealth()
    {
        if self.GetHealth() <= 0
        {
            self.mAlive = false
            super.DestroyWhiteBloodCell(playSound: true)
        }
    }
    
    override func Update(rotationSpeed Speed: Float)
    {
        RotateBackground(rotationSpeed: Speed)
        UpdateHealthBarPosition()
        CheckHealth()
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
