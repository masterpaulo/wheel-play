//
//  GameScene.swift
//  Playground
//
//  Created by Master Paulo on 18/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    
    
    var steeringWheel: SKSpriteNode = SKSpriteNode()
    var steeringIndicator: SKSpriteNode = SKSpriteNode()
    var steeringAngleLabel: SKLabelNode = SKLabelNode()
    
    var startingAngle: CGFloat?
    var startingTime: TimeInterval?
    
    var isGrabbingSteeringWheel: Bool = false
    var steeringTouchNodeID: Int? = nil
    
    var steeringVelocity: CGFloat = 0.0
    
    var steeringAngle: Double = 0.0
    
    // constants
    let steeringAngleLimit: Double = 450
    let steeringVelocitycorrectionAmount = 1
    let maxSteeringVelocity = CGFloat(5)
    
    var lastAngle: CGFloat = 0.0
    var lastTime: TimeInterval = TimeInterval(0)
    
    override func didMove(to view: SKView) {

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.fadeOut(withDuration: 0.5),SKAction.removeFromParent()]))
        }
        
        if let wheel = self.childNode(withName: "SteeringWheel") as? SKSpriteNode{

//            wheel.setScale(0.5)
            steeringWheel = wheel
            steeringWheel.physicsBody = SKPhysicsBody(circleOfRadius: wheel.size.width/2)
            // Change this property as needed (increase it to slow faster)
            steeringWheel.physicsBody!.angularDamping = 3
            steeringWheel.physicsBody?.pinned = true
            steeringWheel.physicsBody?.affectedByGravity = false
        }
        
        if let indicator = self.childNode(withName: "SteeringIndicator") as? SKSpriteNode{
            steeringIndicator = indicator
        }
        
        if let label = self.childNode(withName: "SteeringAngleLabel") as? SKLabelNode{
            steeringAngleLabel = label
        }
    }
    
    
    func touchDown(t : UITouch) {
        
        let location = t.location(in:self)
        let node = atPoint(location)
        if node.name == "SteeringWheel" {
            let dx = location.x - node.position.x
            let dy = location.y - node.position.y
            // Store angle and current time
            startingAngle = radiansToDegress(radians: atan2(dy, dx))
            startingTime = t.timestamp
            node.physicsBody?.angularVelocity = 0
            steeringVelocity = 0.0
            
            isGrabbingSteeringWheel = true
            steeringTouchNodeID = t.hashValue
        }
    }
    
    func touchMoved(t : UITouch) {
        let location = t.location(in:self)
        let node = steeringWheel
        
        if let touchNode = steeringTouchNodeID, let startAngle = startingAngle {
            if isGrabbingSteeringWheel && t.hashValue == touchNode {
                let dx = location.x - node.position.x
                let dy = location.y - node.position.y
                
                let angle = radiansToDegress(radians: atan2(dy, dx))
                
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
            isGrabbingSteeringWheel = false

            steeringTouchNodeID = nil
            startingAngle = nil
            startingTime = nil
        }
    }
    
    // MARK: Steering Actions
    func moveSteeringIndicator(toValue:Double){
        let pos = CGFloat( (steeringAngle / steeringAngleLimit) * -300)
        let move = SKAction.moveTo(x: pos, duration: 0)
        steeringIndicator.run(move)
    }

    func moveSteeringWheel(toAngle: Double){
        let a = degreesToRadians(degrees: CGFloat(steeringAngle))
        let rotate = SKAction.rotate(toAngle: a, duration: 0, shortestUnitArc: true)
        steeringWheel.run(rotate)
    }
    
    func updateSteeringAngle(by deltaAngle:CGFloat){
        steeringAngle += Double(deltaAngle)
        if ( abs( steeringAngle ) > steeringAngleLimit ) {
            steeringAngle = (steeringAngle < 0) ? steeringAngleLimit * -1 : steeringAngleLimit;
            steeringVelocity *= -0.1
        }
        
        steeringAngleLabel.text = String(steeringAngle.rounded())
        moveSteeringIndicator(toValue: steeringAngle)
        moveSteeringWheel(toAngle: steeringAngle)
    }
    
    func updateSteeringWheel(_ currentTime: TimeInterval){
        let currentAngle =  radiansToDegress(radians: steeringWheel.zRotation)
        if !isGrabbingSteeringWheel && steeringAngle != 0.0 {

            // update steering velocity
            if steeringAngle < 5 && steeringAngle > -5 {
                if abs(steeringVelocity) < 10 {
                    steeringVelocity = 0.0
                    steeringAngle = 0.0
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
        lastAngle = currentAngle
    }
    
    
    // MARK: Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(t:t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(t: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t:t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t:t) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        updateSteeringWheel(currentTime)
        
        // the last time interval that the frame updated
        //lastTime = currentTime
    }
    

    
    // MARK: helper functions
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat.pi / 180
    }
    
    func radiansToDegress(radians: CGFloat) -> CGFloat {
        
        return radians * 180 / CGFloat.pi
    }
    
    // Only works for angles by degs not rads
    func angularDistanc(_ a : CGFloat, _ b: CGFloat) -> CGFloat {
        var d = b - a
        if abs(d) > 180 {
            d = d < 0 ? d + 360 : d - 360;
        }
        return d
    }
    
}
