//
//  MainScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/11/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//


import SpriteKit
import CoreMotion

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    private var ship = Spaceship()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        
        
        playButton.text = "Play"
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(playButton)
        self.addChild(ship)
        self.spawnInitialStars()
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)

        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
                let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
                transition.pausesOutgoingScene = false
                transition.pausesIncomingScene = true
                
                let rotateShip = SKAction.rotateByAngle( 2.0*CGFloat(M_PI), duration: 0.05)
                let repeatAction = SKAction.repeatAction(rotateShip, count: 5)
                ship.runAction(repeatAction)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }

    }
    
    func spawnInitialStars() {
        for _ in 1...20 {
            let starYRange = CGFloat(arc4random_uniform(UInt32(self.size.height)))
            spawnNewStar(starYRange)
        }
    }
    
    func spawnNewStar(yPosition: CGFloat) {
        let star = Star()
        let starXRange = CGFloat(arc4random_uniform(UInt32(self.size.width)))
        star.position = CGPoint(x: starXRange, y: yPosition)
        self.addChild(star)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
}
