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
    
    var car: Vehicle = Vehicle()
    
    var steeringWheel: SteeringWheel = SteeringWheel()
    var steeringIndicator: SKSpriteNode = SKSpriteNode()
    var steeringAngleLabel: SKLabelNode = SKLabelNode()
    
    var cam: SKCameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        // Camera Setup
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.fadeOut(withDuration: 0.5),SKAction.removeFromParent()]))
        }
        
        let h = UIScreen.main.bounds.height
        steeringWheel = SteeringWheel()
        steeringWheel.position = CGPoint(x: 0, y: (-h/2 + (h * 0)))
        steeringWheel.setScale(1.5)
        self.camera?.addChild(steeringWheel)
        
        if let vehicle = self.childNode(withName: "Car") as? Vehicle {
            car = vehicle
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
        if let wheel = node as? SteeringWheel {
            wheel.touchDown(t: t)
        }
    }
    
    func touchMoved(t : UITouch) {
        if steeringWheel.state == .hold {
            steeringWheel.touchMoved(t: t)
        }
    }
    
    func touchUp(t: UITouch) {
        if steeringWheel.state == .hold {
            steeringWheel.touchUp(t: t)
        }
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
        
        if(steeringWheel.state != .stop){
            let steeringAngle = steeringWheel.steeringAngle
            
            steeringWheel.update(currentTime)
            moveSteeringIndicator(to: steeringAngle)
            steeringAngleLabel.text = String(steeringAngle.rounded())
            
            car.turn(by: steeringAngle)
            car.update(currentTime)
        }
        

        cam.position = car.position
        // the last time interval that the frame updated
        //lastTime = currentTime
    }
    
    func moveSteeringIndicator(to steeringAngle:Double){
        let limit = steeringWheel.steeringAngleLimit
        let pos = CGFloat( ( steeringAngle / limit) * -300)
        let move = SKAction.moveTo(x: pos, duration: 0)
        steeringIndicator.run(move)
    }
}
