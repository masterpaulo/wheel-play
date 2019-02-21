//
//  Vehicle.swift
//  Playground
//
//  Created by Master Paulo on 21/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import Foundation
import SpriteKit

class Vehicle: SKSpriteNode {
    
    var velocity: Double = 10.00
    
    private var tireAngle: Double = 0.0
    
    var frontDirection: CGFloat {
        get {
            return (self.zRotation + CGFloat.pi / 2)
        }
    }
    
    var rearDirection: CGFloat {
        get {
            return (self.zRotation - CGFloat.pi / 2)
        }
    }
    
    
    
    
    
    func turn(by amount: Double){
        tireAngle = amount / 400
    }
    
    func update(_ currentTime: TimeInterval){
        self.zRotation += CGFloat(tireAngle).degreesToRadians()
        let posX = cos(frontDirection) * CGFloat(velocity)
        let posY = sin(frontDirection) * CGFloat(velocity)
        let direction = CGVector(dx: posX, dy: posY)
        self.run(SKAction.move(by: direction, duration: 0.5))
    }
}
