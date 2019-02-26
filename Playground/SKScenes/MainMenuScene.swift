//
//  MainMenuScene.swift
//  Playground
//
//  Created by Master Paulo on 22/02/2019.
//  Copyright © 2019 Master Paulo. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    var playBtn: SKLabelNode = SKLabelNode()
    var parkBtn: SKLabelNode = SKLabelNode()
    var credBtn: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        
        
        if let play = self.childNode(withName: "PlayButton") as? SKLabelNode{
            playBtn = play
        }
        if let park = self.childNode(withName: "PlayButton") as? SKLabelNode{
            parkBtn = park
        }
        if let cred = self.childNode(withName: "PlayButton") as? SKLabelNode{
            credBtn = cred
        }
        
    }
    
    func presentGame(){
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.view?.presentScene(scene, transition: transition)
        }
        else {
            print("Failed")
        }
        
        
    }
    
    
    func touchDown(t: UITouch){
        let location = t.location(in:self)
        let node = atPoint(location)
        if node.name == "PlayButton" {
            presentGame()
        }
        
    }
    func touchUp(t: UITouch){
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(t:t) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t:t) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
