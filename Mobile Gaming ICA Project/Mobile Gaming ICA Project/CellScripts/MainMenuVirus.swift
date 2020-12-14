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

class MainMenuVirus : Cell
{

    var mMainMenu : MainMenu!

    var mSpeed = Float(1)

    private var mRotationCounter = Float(0)
    
    private var PositionToStore = CGPoint(x: 0, y: 0)
    
    init(back BackTex: String, front FrontTex: String, speed Speed: Float) {
        self.mSpeed = Speed

        //Initialise Cell
        super.init(back: BackTex, front: FrontTex)
    }
    
    //Initialising Main Menu Viruses
    func InitialiseMainMenuVirus(scene Scene: MainMenu, zposition ZPosition: CGFloat)
    {
        self.mMainMenu = Scene
        
        super.SetSize(to: CGSize(width: mMainMenu.frame.maxX / 10, height: mMainMenu.frame.maxX / 10))

        //Initialise Cell Function
        super.InitialiseCellMainMenu(scene: Scene, name: "MainMenuVirus", zposition: ZPosition)
        
        super.SetPosition(to: PositionToStore)
    }
    
    func SpawnMainMenuVirus(at Pos: CGPoint)
    {
        PositionToStore = Pos
        super.SetPosition(to: Pos)
    }

    func SetSpeed(to Speed: Float)
    {
        mSpeed = Speed
    }
        
    //Move Cell Down the screen
    func Move()
    {
        let currentPos = super.GetPosition()
        let newPos = CGPoint(x: currentPos.x, y:
            currentPos.y + CGFloat((-1 * self.mSpeed) * Float(self.mMainMenu.GetDeltaTime()))
                             )
        
        super.SetPosition(to: newPos)
    }
    
    //Sets Cell Alpha value based on vertical screen position
    func UpdateAlpha()
    {
        var newAlphaValue = -0.35 + (super.mCellBackground.position.y / mMainMenu.frame.maxY)
        if newAlphaValue < 0
        {
            newAlphaValue = 0
        }
        super.mCellBackground.alpha = newAlphaValue
        super.mCellForeground.alpha = newAlphaValue
    }
    
    //Rotate Cell background
    func RotateBackground(rotationSpeed Speed: Float)
    {
        let DeltaTime = Float(mMainMenu.GetDeltaTime())
        mCellBackground.zRotation = CGFloat(mRotationCounter)
        mRotationCounter = Float(mRotationCounter) + (Speed * DeltaTime)
    }
    
    //Check if cell is off bottom of screen
    func CheckBottomOfScreen()
    {
        if super.mCellBackground.position.y < -super.mCellBackground.size.height
        {
            super.SetPosition(to: CGPoint(x: super.mCellBackground.position.x, y: mMainMenu.frame.maxY + mCellBackground.size.height))
        }
    }
    
    //Updates Menu Cell Background
    func Update(rotationSpeed Speed: Float)
    {
        Move()
        UpdateAlpha()
        RotateBackground(rotationSpeed: Speed)
        CheckBottomOfScreen()
    }
    
}
