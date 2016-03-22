//
//  ReplayScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/3/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit
import Darwin

class ReplayScene: SKScene {
    
    let lastScore: Int?
    
    init(size: CGSize, score: Int) {
        lastScore = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let hsManager = HighScoreManager()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        let lastScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let highScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        let exitButton = SKLabelNode(fontNamed:"Palatino-Roman")
        let flightNote = SKMultilineLabel(text: "The words used to describe the Ship are not the Ship", labelWidth: Int(self.frame.width), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/8)), fontName: "Palatino-Roman", leading: 22)
        
        
        let cropNode = SKCropNode()
        cropNode.zPosition = 1
        let barPosition = CGPoint(x: 0.0, y: CGFloat(self.frame.height))
        let alphaBarNode = Purplelaser()
        alphaBarNode.alpha = 0.2
        alphaBarNode.position = barPosition
        let barNode = Purplelaser()
        barNode.position = barPosition
        barNode.name = "bar"
        
        let mask = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(barNode.frame.size.width, barNode.frame.size.height))
        mask.position = CGPoint(x: (barNode.position.x - barNode.frame.size.width/2), y: (barNode.position.y))
        cropNode.addChild(barNode)
        cropNode.maskNode = mask
        
        lastScoreLabel.text = String(lastScore!)
        lastScoreLabel.name = "scoreLabels"
        lastScoreLabel.fontSize = 35
        lastScoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/2)
        
        highScoreLabel.text = String(self.hsManager.scores.first!.score)
        highScoreLabel.name = "scoreLabels"
        highScoreLabel.fontSize = 45
        highScoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/3)
        
        playButton.text = "Play Again"
        playButton.name = "playButton"
        playButton.fontSize = 35
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/6)
        
        exitButton.text = "Exit"
        exitButton.name = "exitButton"
        exitButton.fontSize = 30
        exitButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/9)
        
        self.addChild(flightNote)
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
        self.addChild(playButton)
        self.addChild(exitButton)
        self.addChild(alphaBarNode)
        self.addChild(mask)
        self.addChild(cropNode)
        
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
            
            if touchedNode.name == "exitButton" {
                exit(0)
            }
            
            if touchedNode.name == "mask" {
                exit(0)
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
