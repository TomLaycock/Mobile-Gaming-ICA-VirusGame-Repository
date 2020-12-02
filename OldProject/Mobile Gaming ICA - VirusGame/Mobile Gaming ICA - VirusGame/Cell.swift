//
//  Cell.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 01/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Cell
{

    var mCellBackground : SKSpriteNode!
    var mCellForeground : SKSpriteNode!
    
    //Cell Init
    init(back BackTex: String, front FrontTex: String) {
        
        self.mCellBackground = SKSpriteNode(imageNamed: BackTex)
        self.mCellForeground = SKSpriteNode(imageNamed: FrontTex)
        
        self.SetPosition(to: CGPoint(x: -100, y: 0))
        self.SetSize(to: CGSize(width: CGFloat(1), height: CGFloat(1)))
    }
    
    //Cell Functionality
    func SetPosition(to Position: CGPoint)
    {
        self.mCellBackground.position = Position
        self.mCellForeground.position = Position
    }
    
    func SetSize(to Size: CGSize)
    {
        self.mCellBackground.size = Size
        self.mCellForeground.size = Size
    }
    
    func SetName(to Name: String)
    {
        self.mCellBackground.name = Name
        self.mCellForeground.name = Name
    }
    
    func SetZPosition(to Value: CGFloat)
    {
        self.mCellBackground.zPosition = Value
        self.mCellForeground.zPosition = Value + 1
    }
    
    func CallAddChild(scene Scene: SKScene)
    {
        Scene.addChild(self.mCellBackground)
        Scene.addChild(self.mCellForeground)
    }
    
    func InitialiseCell(scene Scene: GameScene, name Name: String, zposition ZPosition: CGFloat)
    {
        self.SetPosition(to: CGPoint(x: -100, y: 0))
        self.SetSize(to: CGSize(width: CGFloat(1), height: CGFloat(1)))
        
        self.SetName(to: Name)
        self.SetZPosition(to: ZPosition)
        self.CallAddChild(scene: Scene)
    }
 
    func GetPosition() -> CGPoint
    {
        return self.mCellBackground.position
    }
    
}
