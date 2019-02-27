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
    var steeringIndicator: SteeringIndicator = SteeringIndicator()
    var steeringAngleLabel: SKLabelNode = SKLabelNode()
    
    var cam: SKCameraNode = SKCameraNode()
    
    var startPoint: SKNode = SKNode()
    
    override func didMove(to view: SKView) {
        
        // Camera Setup
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        
        // Create shape node to use during mouse interaction
        
        
        let h = self.frame.height
        let w = self.frame.width
        steeringWheel = SteeringWheel()
        steeringWheel.position = CGPoint(x: (w * 0), y: (-h / 2 + (h * 0.2)))
        steeringWheel.zPosition = 10
        steeringWheel.setScale(1.5)
        self.camera?.addChild(steeringWheel)
        
        steeringIndicator = SteeringIndicator()
        steeringIndicator.position = CGPoint(x: 0, y: (-h / 2 + (h * 0.0)))
        steeringIndicator.zPosition = 10
        steeringIndicator.setScale(1)
        self.camera?.addChild(steeringIndicator)
        
        
        car = Vehicle(imageNamed: "yellow_car")
        car.zPosition = 9
        car.name = "Car"
        self.addChild(car)
        
        let resetButton = SKSpriteNode(imageNamed: "button_restart")
        resetButton.name = "ResetBtn"
        resetButton.position = CGPoint(x: (w * 0.0), y: (h * 0.45))
        resetButton.setScale(1.5)
        self.camera?.addChild(resetButton)
        
    
        
        if let point = self.childNode(withName: "StartPoint") {
            startPoint = point
        }
        
        if let label = self.childNode(withName: "SteeringAngleLabel") as? SKLabelNode{
            steeringAngleLabel = label
        }
        
        setup()
        
    }
    
    // MARK: - Setup
    
    
    
    func setup() {
        car.position = startPoint.position
        car.zRotation = 0
        car.velocity = 0
        car.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    
    func touchDown(t : UITouch) {
        let location = t.location(in:self)
        let node = atPoint(location)
        if let wheel = node as? SteeringWheel {
            wheel.touchDown(t: t)
        }
        if node.name == "ResetBtn" {
            setup()
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
    
    func adjustCamera(to node: SKNode){
        let delay = 0.5
        let position = node.position
        let rotation = car.zRotation
        
        let move = SKAction.move(to: position, duration: delay)
        let rotate = SKAction.rotate(toAngle: rotation, duration: delay, shortestUnitArc: true)
        
        let adjust = SKAction.group([move])
        cam.run(adjust)
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
            steeringIndicator.set(value: steeringAngle)
            steeringAngleLabel.text = String(steeringAngle.rounded())
            
            car.turn(by: steeringAngle)
            
        }
        
        car.accelerate()
        car.update(currentTime)
        adjustCamera(to: car)
        
        // the last time interval that the frame updated
        //lastTime = currentTime
    }
    
    
}
