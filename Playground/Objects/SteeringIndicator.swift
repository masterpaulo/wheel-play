//
//  SteeringIndicator.swift
//  Playground
//
//  Created by Master Paulo on 22/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import Foundation
import SpriteKit

class SteeringIndicator: SKShapeNode {
    
    private var steeringAngle: Double = 0.0
    private var limit = 450.0
    
    private var bar: SKShapeNode = SKShapeNode()
    private var indicator: SKShapeNode = SKShapeNode()
    
    
    override init() {
        super.init()
        self.name = "SteeringIndicator"

        // Create shape
        let w = CGFloat(500.00)
        let h = CGFloat(10.00)
        
        bar = SKShapeNode.init(rectOf: CGSize.init(width: w, height: h), cornerRadius: h * 0.3)
        indicator = SKShapeNode.init(rectOf: CGSize.init(width: h, height: h), cornerRadius: h * 0.3)
        
        bar.fillColor = .white
        indicator.fillColor = .red
        
        bar.addChild(indicator)
        self.addChild(bar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(value: Double) {
        steeringAngle = value
        let pos = CGFloat( ( steeringAngle / limit) * -250)
        let move = SKAction.moveTo(x: pos, duration: 0)
        indicator.run(move)
    }
    
    func moveSteeringIndicator(to steeringAngle:Double){
        let pos = CGFloat( ( steeringAngle / limit) * -300)
        let move = SKAction.moveTo(x: pos, duration: 0)
        self.run(move)
    }
   
    
    func update(_ currentTime: TimeInterval){
       
    }
}

