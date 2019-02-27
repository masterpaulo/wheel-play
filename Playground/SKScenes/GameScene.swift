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
    
    override func didMove(to view: SKView) {
        
        // Camera Setup
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        
        // Create shape node to use during mouse interaction
        
        
        var h = self.frame.height
//        h = UIScreen.main.bounds.height
        steeringWheel = SteeringWheel()
        steeringWheel.position = CGPoint(x: 0, y: (-h/2 + (h * 0.2)))
        steeringWheel.zPosition = 10
        steeringWheel.setScale(1.5)
        self.camera?.addChild(steeringWheel)
        
        steeringIndicator = SteeringIndicator()
        steeringIndicator.position = CGPoint(x: 0, y: (-h/2 + (h * 0.0)))
        steeringIndicator.zPosition = 10
        steeringIndicator.setScale(1)
        self.camera?.addChild(steeringIndicator)
        
        
        let vehicle: Vehicle = Vehicle(imageNamed: "yellow_car")
        car = vehicle
        car.zPosition = 9
        car.name = "Car"
        car.setScale(0.1)
        self.addChild(car)
        
        
        if let startPoint = self.childNode(withName: "StartPoint") {
            car.position = startPoint.position
            
        }
        
        if let label = self.childNode(withName: "SteeringAngleLabel") as? SKLabelNode{
            steeringAngleLabel = label
        }
        
        if let road = self.childNode(withName: "OuterMap") as? SKSpriteNode{
            let texture = road.texture!
            road.physicsBody = SKPhysicsBody(texture: texture, size: road.size)
            road.physicsBody?.affectedByGravity = false
            road.physicsBody?.allowsRotation = false
            road.physicsBody?.isDynamic = false
        }
    }
    
    // MARK: - Setup
    
    func setup() {
        
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
    
    func adjustCamera(to node: SKNode){
        let delay = 0.5
        let position = node.position
        let rotation = car.zRotation
        
        let move = SKAction.move(to: position, duration: delay)
        let rotate = SKAction.rotate(toAngle: rotation, duration: delay, shortestUnitArc: true)
        
        let adjust = SKAction.group([move, rotate])
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
            car.update(currentTime)
        }
        
        car.accelerate()
        adjustCamera(to: car)
        
        // the last time interval that the frame updated
        //lastTime = currentTime
    }
    
    
}
