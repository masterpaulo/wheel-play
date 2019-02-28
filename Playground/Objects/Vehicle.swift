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
    
    
    var velocity: CGFloat = 0.0
    var topSpeed: Double = 100
    var acceleration: Double = 0
    var mass: Double = 1300.00
    
    private var tireAngle: Double = 0.0
    private var maxAngle: Double = 45.00
    
    
    enum Gear : Int{
        case reverse = -1
        case neutral = 0
        case first = 1
        case second = 2
        case third = 3
        case fourth = 4
        case fifth = 5
        
        var display: String {
            switch self {
                case .reverse: return "R"
                case .neutral: return "N"
                case .first: return "1"
                case .second: return "2"
                case .third: return "3"
                case .fourth: return "4"
                case .fifth: return "5"
            }
        }
        
        func acceleration() -> Double {
            switch self {
                case .reverse: return -30
                case .neutral: return 0
                case .first: return 30
                case .second: return 50
                case .third: return 70
                case .fourth: return 90
                case .fifth: return 100
            }
        }
        
        func nextUp() -> Gear? {
            switch self {
                case .reverse: return .neutral
                case .neutral: return .first
                case .first: return .second
                case .second: return .third
                case .third: return .fourth
                case .fourth: return .fifth
                case .fifth: return nil
            }
        }
        
        func nextDown() -> Gear? {
            switch self {
                case .reverse: return nil
                case .neutral: return .reverse
                case .first: return .neutral
                case .second: return .first
                case .third: return .second
                case .fourth: return .third
                case .fifth: return .fourth
            }
        }
    }
    
    var currentGear: Gear = .neutral
    
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
    
    var motionSpeed: CGFloat {
        get {
            let v = self.physicsBody?.velocity
            if let vX = v?.dx, let vY = v?.dy {
                return hypot(vX, vY)
            }
            return 0.0
        }
    }
    
    var motionDirection: CGFloat {
        get {
            let v = self.physicsBody?.velocity
            if let vX = v?.dx, let vY = v?.dy {
                return atan2(vY, vX)
            }
            return 0.0
        }
    }
    
    
    // MARK: - Init
    
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
    }
    
    // MARK: - Setup
    
    func setup() {
        self.name = "Vehicle"
        
        physicsBody = SKPhysicsBody(texture: self.texture!, size: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.mass = CGFloat(mass)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 0.01
    }
    
    // MARK: - Object Actions
    
    func turn(by amount: Double){
        tireAngle = amount / 10
        //let tireDirection = CGFloat(tireAngle * maxAngle).degreesToRadians()
        //let turnAngle = frontDirection + tireDirection
        
        let speed = motionSpeed.rounded()
        var factor: CGFloat = speed / 100 / 60 / 45
        factor *= currentGear == .reverse ? -1 : 1;

        let rotate = SKAction.rotate(byAngle: CGFloat(tireAngle) * factor, duration: 0)
        
        self.run(rotate)
    }
    
    // Only go forward towards front Direction
    func accelerate() {
        let posX = cos(frontDirection) * CGFloat(acceleration) * CGFloat(mass)
        let posY = sin(frontDirection) * CGFloat(acceleration) * CGFloat(mass)
        
        let direction = CGVector(dx: posX, dy: posY)
        
//        print("accelration force :: \(direction) ||||| speed \(motionSpeed)")
        
        self.physicsBody?.applyForce(direction)
    }
    
    func shift(to gear: Gear){
        currentGear = gear
        acceleration = gear.acceleration()
    }
    
    
    
    
    // MARK: - Supporting Physics
    
    /**
     Kill Lateral Velocity of moving body
     
     - parameters:
        - drift: Defines the amount of drift. A Double value from 0.0 to 1.0.
     
     The `drift` value defines how much lateral velocity would be retained on the moving body
    */
    func killLateralVelocity(drift: Double){
        // let multiplier = 100.0 / motionSpeed ?
        let dAngle = shortestAngleBetween(motionDirection, frontDirection)
        if motionSpeed > 1 {
            let frontSpeed = cos(dAngle) * motionSpeed
            let lateralSpeed = sin(dAngle) * motionSpeed
            
            let frontAngle = frontDirection
            let lateralAngle = zRotation
            
            let frontY = sin(frontAngle) * frontSpeed
            let frontX = cos(frontAngle) * frontSpeed
            
            let lateralY = sin(lateralAngle) * lateralSpeed * CGFloat(drift)
            let lateralX = cos(lateralAngle) * lateralSpeed * CGFloat(drift)
            
            let frontVelocity = CGVector(dx: frontX + lateralX, dy: frontY + lateralY)
            
            self.physicsBody?.velocity = frontVelocity
        }
    }
    
    func limitMotionSpeed() {
        let dAngle = shortestAngleBetween(motionDirection, frontDirection)
        if motionSpeed > 1 {
            let frontSpeed = cos(dAngle) * motionSpeed
            if frontSpeed > CGFloat(topSpeed) {
                print("limit motion speed")
            }
        }
    }
    
    // MARK: - Update
    
    func update(_ currentTime: TimeInterval){
        killLateralVelocity(drift: 0.2)
    }
}
