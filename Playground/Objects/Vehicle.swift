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
    
    var velocity: Double = 0.00
    
    private var tireAngle: Double = 0.0
    
    var frontDirection: Double {
        get {
            return Double(self.zPosition.radiansToDegrees() + 90 )
        }
    }
    
    var rearDirection: Double {
        get {
            return Double(self.zPosition.radiansToDegrees() - 90 )
        }
    }
    
    
    
    
    
    func turn(by amount: Double){
        tireAngle = amount / 400
    }
    
    func update(_ currentTime: TimeInterval){
        self.zRotation += CGFloat(tireAngle).degreesToRadians()
        
    }
}
