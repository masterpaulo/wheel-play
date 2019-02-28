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
    var marginLine: SKShapeNode = SKShapeNode()
    
    var menuWindow: GameMenu = GameMenu()
    var startPoint: SKNode = SKNode()
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    var maxAspectRatio: CGFloat = 0.0
    var playableArea: CGRect = CGRect()
    
    override func didMove(to view: SKView) {
        
        drawPlayableArea()
        
        // Camera Setup
        cam = SKCameraNode()
        cam.addChild(marginLine)
        self.camera = cam
        self.addChild(cam)
        
        let h = playableArea.height
        let w = playableArea.width
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
        
        let pauseButton = SKSpriteNode(imageNamed: "button_pause")
        pauseButton.name = "PauseButton"
        pauseButton.position = CGPoint(x: (w * 0.0), y: (h * 0.45))
        pauseButton.setScale(3)
        self.camera?.addChild(pauseButton)
        
        menuWindow = GameMenu(size: playableArea.size)
        menuWindow.position = CGPoint(x: 0, y: 0)
        self.camera?.addChild(menuWindow)
        
    
        
        if let point = self.childNode(withName: "StartPoint") {
            startPoint = point
        }
        
        if let label = self.childNode(withName: "SteeringAngleLabel") as? SKLabelNode{
            steeringAngleLabel = label
        }
        
        setup()
        
    }
    
    
    
    // MARK: - Setup
    
    func drawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        
        maxAspectRatio = deviceHeight / deviceWidth
        
        let size = CGSize(width: 768, height: 1024)
        
        //USE THIS CODE IF YOUR APP IS IN PORTRAIT MODE
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableArea = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)

        //USE THIS CODE IF YOUR APP IS IN LANDSCAPE MODE
        //let playableHeight = size.width / maxAspectRatio
        //let playableMargin = (size.height - playableHeight) / 2.0
        //playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        
        path.addRect(playableArea)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 8
        marginLine = shape
        cam.addChild(shape)
    }
    
    func setup() {
        car.position = startPoint.position
        car.zRotation = 0
        car.velocity = 0
        car.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func pause() {
        // We don't PAUSE in this game \(^ ^)/
        //self.view?.isPaused = !(self.view?.isPaused)!
        //self.scene?.isPaused = !isPaused
    }
    
    // MARK: - User Actions
    
    func touchDown(t : UITouch) {
        let location = t.location(in:self)
        let node = atPoint(location)
        print(node)
        
        if node.name == "PauseButton" {
            menuWindow.showMenu()
            return
        }
        if node.name == "OkButton" {
            menuWindow.hideMenu()
            return
        }
        if node.name == "ResetButton" {
            setup()
            menuWindow.hideMenu()
            return
        }
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
        //let rotate = SKAction.rotate(toAngle: rotation, duration: delay, shortestUnitArc: true)
        
        let adjust = SKAction.group([move])
        cam.run(adjust)
    }
    
    
    func swipedRight() {
        
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
    }
    
    
}
