//
//  GameMenu.swift
//  Playground
//
//  Created by Master Paulo on 28/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenu : SKShapeNode {
    
    
    var menuSize: CGSize = CGSize(width: 0, height: 0)
    
    var menuFrame: SKShapeNode = SKShapeNode()
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGSize){
        self.init()
        menuSize = size
        setup()
    }
    
    func setup() {
        menuFrame = SKShapeNode(rectOf: CGSize(width: menuSize.width, height: menuSize.height), cornerRadius: 15)
        menuFrame.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        menuFrame.zPosition = 15
        menuFrame.strokeColor = .clear
        menuFrame.isHidden = true
        menuFrame.position = CGPoint(x: 0, y: menuSize.height * 2)
        
        let text = SKLabelNode(fontNamed: "Futura")
        text.text = "We don't pause this game"
        text.position = CGPoint(x: 0, y: 150)
        menuFrame.addChild(text)
        
        let resetButton = SKSpriteNode(imageNamed: "button_restart")
        let homeButton = SKSpriteNode(imageNamed: "button_home")
        let okButton = SKSpriteNode(imageNamed: "button_ok")
        
        resetButton.name = "ResetButton"
        homeButton.name = "HomeButton"
        okButton.name = "OkButton"
        
        resetButton.setScale(3.0)
        homeButton.setScale(3.0)
        okButton.setScale(3.0)
        
        resetButton.position = CGPoint(x: menuSize.width / 2 * 0.5, y: menuSize.height / 2 * -0.5)
        homeButton.position = CGPoint(x: menuSize.width / 2 * 0.0, y: menuSize.height / 2 * -0.5)
        okButton.position = CGPoint(x: menuSize.width / 2 * -0.5, y: menuSize.height / 2 * -0.5)
        
        menuFrame.addChild(resetButton)
        menuFrame.addChild(homeButton)
        menuFrame.addChild(okButton)
        
        self.addChild(menuFrame)
    }
    
    func showMenu() {
        menuFrame.position = CGPoint(x: 0, y: menuSize.height * 1)
        let show = SKAction.unhide()
        let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
        move.timingMode = .easeOut
        menuFrame.run(SKAction.sequence([ show, move ]))
        
    }
    
    func hideMenu() {
        let hide = SKAction.hide()
        let move = SKAction.move(to: CGPoint(x: 0, y: menuSize.height * 1), duration: 0.5)
        move.timingMode = .easeIn
        
        menuFrame.run(SKAction.sequence([ move, hide ]))
    }
}
