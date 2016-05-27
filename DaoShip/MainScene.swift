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
        
        let topColor = UIColor(red:0.19, green:0.16, blue:0.46, alpha:1.0)
        let bottomColor = UIColor.blackColor()
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.frame
//        gradientLayer.zPosition = -1
//        gradientLayer.anchorPointZ = -1.0
//        let context = UIGraphicsGetCurrentContext()
        
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
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
