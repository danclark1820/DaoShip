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
        
        playButton.text = "Continue"
        playButton.name = "playButton"
        playButton.fontSize = 30
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/2)
        
        rateButton.text = "Rate DaoShip"
        rateButton
        rateButton.name = "rateButton"
        rateButton.fontSize = 30
        rateButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        rateButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/3)
        
        shareButton.text = "Share"
        shareButton
        shareButton.name = "shareButton"
        shareButton.fontSize = 30
        shareButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        shareButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/5)
        
        self.addChild(playButton)
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
        self.addChild(rateButton)
        self.addChild(shareButton)
        self.spawnInitialStars()
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
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(959379869)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
    }
    
    @IBAction func shareButtonClicked() {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
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
