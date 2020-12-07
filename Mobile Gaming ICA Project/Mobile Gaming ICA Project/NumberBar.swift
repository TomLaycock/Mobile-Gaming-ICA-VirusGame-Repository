//
//  NumberBar.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 30/11/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class NumberBar {
    
    var mCurrentNumber = 0
    var mNumberBarMax = 0
    
    var mBarMaxLentgh = CGFloat(100)
    var mBarMaxHeight = CGFloat(15)
    
    var mBarBackground = SKSpriteNode()
    var mBarForeground = SKSpriteNode()
    
    let mBarValueDisplay = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    init(Start StartingValue: Int, Max MaxValue: Int, BackPath BackgroundImagePath: String, ForePath ForegroundImagePath: String, Lentgh MaxLentgh: CGFloat, Height MaxHeight: CGFloat)
    {
        mCurrentNumber = StartingValue
        mNumberBarMax = MaxValue
        
        mBarMaxLentgh = MaxLentgh
        mBarMaxHeight = MaxHeight
        
        mBarBackground = SKSpriteNode(imageNamed: BackgroundImagePath)
        mBarForeground = SKSpriteNode(imageNamed: ForegroundImagePath)

        mBarBackground.anchorPoint = CGPoint(x: 0, y: 0.5)
        mBarForeground.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        mBarValueDisplay.fontSize = 23
        mBarValueDisplay.text = "" + String(mCurrentNumber)
        mBarValueDisplay.horizontalAlignmentMode = .center
        mBarValueDisplay.verticalAlignmentMode = .center
                    
        self.UpdateBarDisplay()
    }
    
    //Functions to Get DisplayableElements
    func GetBarBackground() -> SKSpriteNode
    {
        return mBarBackground
    }
    
    func GetBarForeground() -> SKSpriteNode
    {
        return mBarForeground
    }
    
    func GetBarText() -> SKLabelNode
    {
        return mBarValueDisplay
    }
    
    //Functions to manipulate bar position
    func SetBarPosition(to Position: CGPoint)
    {
        mBarBackground.position = Position
        mBarForeground.position = CGPoint(x: Position.x + 2, y: Position.y)

        mBarBackground.size = CGSize(width: mBarMaxLentgh, height: mBarMaxHeight)
        mBarForeground.size = CGSize(width: mBarMaxLentgh - 4, height: mBarMaxHeight - 4)

        mBarValueDisplay.position = CGPoint(x: Position.x + mBarMaxLentgh / 2, y: Position.y + 0)
        
        self.UpdateBarDisplay()
    }
    
    func SetBarZPosition(to Number: Int)
    {
        mBarBackground.zPosition = CGFloat(Number)
        mBarForeground.zPosition = CGFloat(Number + 1)
        mBarValueDisplay.zPosition = CGFloat(Number + 2)
    }
    
    //Functions For Bars Number Value
    func SetNumberBarMax(to Number: Int)
    {
        mNumberBarMax = Number
        self.UpdateBarDisplay()
    }
    
    func SetNumberBarValue(to Number: Int)
    {
        mCurrentNumber = Number
        self.UpdateBarDisplay()
    }
    
    func IncreaseNumberBarValue(by Number: Int)
    {
        mCurrentNumber = mCurrentNumber + Number
        self.UpdateBarDisplay()
    }
    
    func DecreaseNumberBarValue(by Number: Int)
    {
        mCurrentNumber = mCurrentNumber - Number
        self.UpdateBarDisplay()
    }
    
    //Updating the Bar On Edit
    func UpdateBarDisplay()
    {
        mBarValueDisplay.text = "" + String(mCurrentNumber)
        
        var newBarWidth = Float(Float(mBarMaxLentgh - 4) / Float(mNumberBarMax)) * Float(mCurrentNumber)

        if(newBarWidth > Float(mBarMaxLentgh - 4))
        {
            newBarWidth = Float(mBarMaxLentgh)
        }
        else if(newBarWidth < 0)
        {
            newBarWidth = 0
        }
        
        mBarForeground.size = CGSize(width: Int(newBarWidth), height: Int(mBarMaxHeight - 4))
    }
    
}
