//
//  MainScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/11/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//


import SpriteKit

class MainScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        
        playButton.text = "Play"
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(playButton)
        
        self.backgroundColor = UIColor.blackColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
