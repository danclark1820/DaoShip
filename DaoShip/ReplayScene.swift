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
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)
        let lastScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let highScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let playButton = SKLabelNode(fontNamed: "Palatino-Roman")
        let rateButton = SKLabelNode(fontNamed: "Palatino-Roman")
        let shareButton = SKLabelNode(fontNamed: "Palatino-Roman")
        let newHighScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let highScoreNumber = SKLabelNode(fontNamed: "Palatino-Roman")
        let ship = Spaceship()
        
        highScoreLabel.text = "High: " + String(self.hsManager.scores.first!.score)
        highScoreLabel.name = "scoreLabels"
        highScoreLabel.fontSize = 20
        highScoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        highScoreLabel.position = CGPoint(x: (self.frame.width - highScoreLabel.frame.width/2), y: (self.frame.height - highScoreLabel.frame.height))
        
        lastScoreLabel.text = "Previous: " + String(lastScore!)
        lastScoreLabel.name = "scoreLabels"
        lastScoreLabel.fontSize = 20
        lastScoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        lastScoreLabel.position = CGPoint(x: (0.0 + lastScoreLabel.frame.width/2), y: (self.frame.height - highScoreLabel.frame.height))
        
        playButton.text = "Try Again"
        playButton.name = "playButton"
        playButton.fontSize = 35
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position =  CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/5)
        
        rateButton.text = "Rate ShipDip"
        rateButton.name = "rateButton"
        rateButton.fontSize = 30
        rateButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        rateButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(9/20))
        
        shareButton.text = "Challange Friends"
        shareButton.name = "shareButton"
        shareButton.fontSize = 35
        shareButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        shareButton.position =  CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(11/20))
        
        newHighScoreLabel.text = "High Score!"
        newHighScoreLabel.name = "playButton"
        newHighScoreLabel.fontSize = 45
        newHighScoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        newHighScoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(4/5))
        
        highScoreNumber.text = "\(self.hsManager.scores.first!.score)"
        highScoreNumber.name = "playButton"
        highScoreNumber.fontSize = 80
        highScoreNumber.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        highScoreNumber.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(2/3))
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        
        if lastScore! == self.hsManager.scores.first!.score {
            self.addChild(newHighScoreLabel)
            self.addChild(highScoreNumber)
            self.addChild(rateButton)
            self.addChild(shareButton)
        }
        
        self.addChild(ship)
        let rotateShip = SKAction.rotateByAngle(2.0*CGFloat(M_PI), duration: 0.05)
        let repeatAction = SKAction.repeatAction(rotateShip, count: 5)
        ship.runAction(repeatAction)
        
        self.addChild(playButton)
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
        self.spawnInitialStars()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
                let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            } else if touchedNode.name == "rateButton" {
                rateApp()
            } else if touchedNode.name == "shareButton" {
                shareButtonClicked()
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
    
    func rateApp(){
//        How do we get the link to the app store before its in the app store
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(959379869)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
    }
    
    @IBAction func shareButtonClicked() {
        let textToShare = "ShipDip is a blast! My best score so far is a \(self.hsManager.scores.first!.score) !"
        
//      Link to app in app store
        if let myWebsite = NSURL(string: "https://itunes.apple.com/us/genre/ios/id36?mt=8") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeMessage, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop]
            //
            
            activityVC.popoverPresentationController?.sourceView
            let vc: UIViewController = (self.view?.window?.rootViewController!)!
            vc.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
