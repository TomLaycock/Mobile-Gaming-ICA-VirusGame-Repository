//
//  Utility.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by Tom on 01/12/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Vector2
{
    var x: Float!
    var y: Float!
    
    init(x X: Float, y Y: Float)
    {
        self.x = X
        self.y = Y
    }
    
    init(CGPoint cg: CGPoint)
    {
        self.x = Float(cg.x)
        self.y = Float(cg.y)
    }
}

extension Vector2
{
    static func -(v1: Vector2, v2: Vector2) -> Vector2 {
        return Vector2(x: v1.x - v2.x, y: v1.y - v2.y)
    }
    
    static func +(v1: Vector2, v2: Vector2) -> Vector2 {
        return Vector2(x: v1.x + v2.x, y: v1.y + v2.y)
    }
    
    static func magnitude(v: Vector2) -> CGFloat {
        return CGFloat(sqrt(pow(Float(v.x) ,2) + pow(Float(v.y), 2)))
    }

    static func normalise(v: Vector2) -> Vector2 {
        return Vector2(x: Float(CGFloat(v.x) / magnitude(v: v)), y: Float(CGFloat(v.y) / magnitude(v: v)))
    }
}

extension CGPoint
{
    static func +(v1: CGPoint, v2: CGPoint) -> CGPoint {
        return CGPoint(x: v1.x + v2.x, y: v1.y + v2.y)
    }
}
