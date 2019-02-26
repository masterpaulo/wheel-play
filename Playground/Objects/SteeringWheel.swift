//
//  SteeringWheel.swift
//  Playground
//
//  Created by Master Paulo on 21/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import Foundation
import SpriteKit

class SteeringWheel: SKSpriteNode {
    
    var steeringAngle: Double = 0.0
    var state : SteeringWheelState = .stop
    
    private var steeringTouchNodeID: Int? = nil
    
    private var steeringVelocity: CGFloat = 0.0
    
    // constants
    let steeringAngleLimit: Double = 450
    let steeringVelocitycorrectionAmount = 1
    let maxSteeringVelocity = CGFloat(5)
    
    
    private var startingAngle: CGFloat?
    private var startingTime: TimeInterval?
    
    
    enum SteeringWheelState : String{
        case hold = "steering" // grabbed angle any
        case release = "counterSteering" // not grabbed angle not 0
        case stop = "neutral" // not grabbed angle 0
    }
    
    
    init() {
        // super.init(imageNamed: String) You can't do this because you are not calling a designated initializer.
        let texture = SKTexture(imageNamed: "ui_wheel_hd")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "SteeringWheel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func moveSteeringWheel(toAngle: Double){
        let a = CGFloat(steeringAngle).degreesToRadians()
        let rotate = SKAction.rotate(toAngle: a, duration: 0, shortestUnitArc: true)
        self.run(rotate)
    }
    
    func updateSteeringAngle(by deltaAngle:CGFloat){
        steeringAngle += Double(deltaAngle)
        if ( abs( steeringAngle ) > steeringAngleLimit ) {
            steeringAngle = (steeringAngle < 0) ? steeringAngleLimit * -1 : steeringAngleLimit;
            steeringVelocity *= -0.1
        }
        moveSteeringWheel(toAngle: steeringAngle)
    }
    

    // MARK: Touch Actions
    
    func touchDown(t : UITouch) {
        let location = t.location(in:self.parent!)
        let dx = location.x - self.position.x
        let dy = location.y - self.position.y
        // Store angle and current time
        startingAngle = atan2(dy, dx).radiansToDegrees()
        startingTime = t.timestamp
        self.physicsBody?.angularVelocity = 0
        steeringVelocity = 0.0
        
        self.state = .hold
        steeringTouchNodeID = t.hashValue
    }
    
    func touchMoved(t : UITouch) {
        let location = t.location(in:self.parent!)
        let node = self
        
        if let touchNode = steeringTouchNodeID, let startAngle = startingAngle {
            if state == .hold && t.hashValue == touchNode {
                let dx = location.x - node.position.x
                let dy = location.y - node.position.y
                
                let angle = atan2(dy, dx).radiansToDegrees()
                
                // let dt = CGFloat(t.timestamp - startingTime!)
                
                // Calculate angular velocity; handle wrap at pi/-pi
                let deltaAngle = angularDistanc(startAngle, angle)
                steeringVelocity = deltaAngle
                updateSteeringAngle(by: deltaAngle)
                
                // Update angle and time
                startingAngle = angle
                startingTime = t.timestamp
            }
        }
    }
    
    func touchUp(t: UITouch) {
        if let touchNode = steeringTouchNodeID, touchNode == t.hashValue {
            self.state = .release
            
            steeringTouchNodeID = nil
            startingAngle = nil
            startingTime = nil
        }
    }
    
    // MARK: Update function
    
    func update(_ currentTime: TimeInterval){
        if state == .release {
            
            // update steering velocity
            if steeringAngle < 5 && steeringAngle > -5 {
                if abs(steeringVelocity) < 10 {
                    steeringVelocity = 0.0
                    steeringAngle = 0.0
                    state = .stop
                }
            }
            else {
                let correction = steeringVelocitycorrectionAmount
                let max = maxSteeringVelocity
                if steeringAngle > 0 {
                    let change = steeringVelocity > -max ? -correction : correction/2
                    steeringVelocity += CGFloat(change)
                }
                else {
                    let change = steeringVelocity < max ? -correction : correction/2
                    steeringVelocity -= CGFloat(change)
                }
            }
            
            // update steering wheel via velocity
            updateSteeringAngle(by: steeringVelocity)
        }
    }
}
