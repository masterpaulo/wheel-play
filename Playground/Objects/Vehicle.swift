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
    
    
    var velocity: CGVector = CGVector(dx: 0, dy: 0)
    var topSpeed: Double = 100
    var mass: Double = 1300.00
    
    private var tireAngle: Double = 0.0
    private var maxAngle: Double = 45.00
    
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
    
    var frontPoint: CGPoint {
        get {
            let h = (self.texture?.size().height)! / 2
            return CGPoint(x: 0.0, y: h  )
        }
    }
    
    var rearPoint: CGPoint {
        get {
            let h = (self.texture?.size().height)! / 2
            return CGPoint(x: 0.0, y: -h)
        }
    }
    
    
    // MARK: init
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageNamed image: String){
        let texture = SKTexture(imageNamed: image)
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        setup()
        
//        self.anchorPoint = CGPoint(x: 0, y: 0)
        
    }
    
    // MARK: setup
    
    func setup() {
        self.name = "Vehicle"
        
        physicsBody = SKPhysicsBody(texture: self.texture!, size: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = CGFloat(mass)
    }
    
    
    func turn(by amount: Double){
        tireAngle = amount / 450
        let tireDirection = CGFloat(tireAngle * maxAngle).degreesToRadians()
        let turnAngle = frontDirection + tireDirection
        
        let speed = CGFloat(topSpeed)
        let factor: CGFloat = 5 / 60
        
        let lx = cos(turnAngle) * speed * factor
        let ly = sin(turnAngle) * speed * factor
        
        let velocity = CGVector(dx: lx, dy: ly)
//        self.physicsBody?.applyForce(friction)
        
//        self.zRotation += CGFloat(tireAngle).degreesToRadians() * 1
        
        let rotate = SKAction.rotate(byAngle: CGFloat(tireAngle) * factor, duration: 0)
        let push = SKAction.move(by: velocity, duration: 0)
        let action = SKAction.group([rotate, push])
        self.run(rotate)
//        print(frontDirection, tireAngle, tireDirection, turnAngle)
    }
    
    func accelerate() {
        
        let d = frontDirection
        let posX = cos(d) * CGFloat(topSpeed) * CGFloat(mass)
        let posY = sin(d) * CGFloat(topSpeed) * CGFloat(mass)
        let direction = CGVector(dx: posX, dy: posY)
        self.physicsBody?.applyForce(direction)
//        print(self.zRotation, self.frontPoint, self.rearPoint)
        
        killLateralVelocity(drift: 0.0)
    }
    
    func killLateralVelocity(drift: Double){
        var v = self.physicsBody?.velocity
        
//        self.physicsBody?.velocity = v ?? CGVector(dx: 0, dy: 0)
        
        
        if let vX = v?.dx, let vY = v?.dy {
            let velocityAngle = atan2(vY, vX)
            let len = hypot(vX, vY)
            let multiplier = 100.0 / len
//            v?.dx *= multiplier
//            v?.dy *= multiplier
            
            let dAngle = shortestAngleBetween(velocityAngle, frontDirection)
            if len < 1 {
                
            }
            else{
//                print(len, dAngle.radiansToDegrees(), velocityAngle, frontDirection)
                let frontSpeed = cos(dAngle) * len
                let lateralSpeed = sin(dAngle) * len
                
                let frontAngle = frontDirection
                let lateralAngle = zRotation
                
                let frontY = sin(frontAngle) * frontSpeed
                let frontX = cos(frontAngle) * frontSpeed
                
                let frontVelocity = CGVector(dx: frontX, dy: frontY)
                
                print(frontVelocity, v!, frontSpeed)
                self.physicsBody?.velocity = frontVelocity
            }
            
            
        }
        

        
//        if let vX = v?.dx, let vY = v?.dy {
//            let movingDirection = atan2(vY, vX)
//            let movingForce = hypot(vX, vY)
//
//
////            print("motion direction \(movingDirection.radiansToDegrees())")
//
////            let turnAngle = frontDirection + CGFloat(tireAngle * maxAngle).degreesToRadians()
//            let turnAngle = frontDirection
////            print("turn angle \(turnAngle.radiansToDegrees())")
//
//            let dAngle = shortestAngleBetween(movingDirection, turnAngle)
//            print("delta angle \(dAngle.radiansToDegrees()) \(movingForce)")
//
//            let y = sin(dAngle) * movingForce // forward velocity
//            let x = cos(dAngle) * movingForce // lateral velocity
//            print("xy : \(x), \(y)")
//
//            //eliminate x
//            var lateralAngle: CGFloat = 0.0
//            if movingDirection > turnAngle {
//                lateralAngle = turnAngle - CGFloat.pi / 2
//            }
//            else {
//                lateralAngle = turnAngle + CGFloat.pi / 2
//            }
//            print("LATERAL A \(lateralAngle)")
//
//            let factor: CGFloat = 100.00
//
//            let lx = cos(lateralAngle) * x * factor
//            let ly = sin(lateralAngle) * x * factor
//
//            let friction = CGVector(dx: lx, dy: ly)
////            self.physicsBody?.applyImpulse(friction)
////            self.physicsBody?.velocity = friction
//        }
        
    }
    
    func update(_ currentTime: TimeInterval){
//        self.zRotation += CGFloat(tireAngle).degreesToRadians()
//        killLateralVelocity()
//        self.run(SKAction.move(by: direction, duration: 0.5))
    }
}
