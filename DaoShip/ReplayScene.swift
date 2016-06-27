//
//  ReplayScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/3/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit
import Darwin
import GameKit
import AVFoundation

class ReplayScene: SKScene, GKGameCenterControllerDelegate{
    
    let lastScore: Int?
    var audioPlayer: AVAudioPlayer?
    
    init(size: CGSize, score: Int) {
        lastScore = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let hsManager = HighScoreManager()
    let ship = Spaceship()
    
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
        let submitScore = SKLabelNode(fontNamed: "Palatino-Roman")
        let highScoreValue = self.hsManager.scores.first!.score
        
        highScoreLabel.text = "High: " + String(highScoreValue)
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
        
        shareButton.text = "Challenge Friends"
        shareButton.name = "shareButton"
        shareButton.fontSize = 35
        shareButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        shareButton.position =  CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(11/20))
        
        if highScoreValue == 9999 {
            newHighScoreLabel.text = "Max Score!"
        } else {
            newHighScoreLabel.text = "High Score!"
        }
        newHighScoreLabel.name = "playButton"
        newHighScoreLabel.fontSize = 45
        newHighScoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        newHighScoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(4/5))
        
        highScoreNumber.text = "\(highScoreValue)"
        highScoreNumber.name = "playButton"
        highScoreNumber.fontSize = 80
        highScoreNumber.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        highScoreNumber.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(2/3))
        
        submitScore.text = "Submit Score"
        submitScore.name = "submitScore"
        submitScore.fontSize = 30
        submitScore.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        submitScore.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height*(9/20))
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        
        if lastScore! == self.hsManager.scores.first!.score {
            self.addChild(newHighScoreLabel)
            self.addChild(highScoreNumber)
            self.addChild(submitScore)
            self.addChild(shareButton)
        }
        
        let audioURL = NSBundle.mainBundle().URLForResource("ShipDipTheme", withExtension: "m4a")!
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("audioPlayer failure")
        }
        
        self.play()
        self.addChild(ship)
        self.addChild(playButton)
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
        self.spawnInitialStars()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            let rotateShip = SKAction.rotateByAngle(2.0*CGFloat(M_PI), duration: 0.05)
            let repeatAction = SKAction.repeatAction(rotateShip, count: 5)
            
            if touchedNode.name == "playButton" || touchedNode.name == "ship"{
                fadeVolumeAndPause()
                ship.runAction(repeatAction, completion: {
                    let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
                    let nextScene = GameScene(size: self.scene!.size)
                    nextScene.scaleMode = .AspectFill
                
                    self.scene?.view?.presentScene(nextScene, transition: transition)
                })
            } else if touchedNode.name == "rateButton" {
                fadeVolumeAndPause()
                ship.runAction(repeatAction)
                rateApp()
            } else if touchedNode.name == "submitScore" {
                fadeVolumeAndPause()
                ship.runAction(repeatAction)
                submitHighscore(self.hsManager.scores.first!.score)
                showLeaderBoard()
            } else if touchedNode.name == "shareButton" {
                fadeVolumeAndPause()
                ship.runAction(repeatAction)
                shareButtonClicked()
            }

        }
        
    }
    
    func play() {
        audioPlayer?.currentTime = 0
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }
    
    func fadeVolumeAndPause() {
        if self.audioPlayer?.volume > 0.1 {
            self.audioPlayer?.volume = self.audioPlayer!.volume - 0.1
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeVolumeAndPause()
            })
            
        } else {
            self.audioPlayer?.pause()
            self.audioPlayer?.volume = 1.0
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
        UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/us/app/shipdip/id1121208467?ls=1&mt=8")!);
    }
    
    @IBAction func shareButtonClicked() {
        UIGraphicsBeginImageContext(self.view!.bounds.size)
        self.view!.drawViewHierarchyInRect(self.view!.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let textToShare = "ShipDip is my new jam! Just scored a \(self.hsManager.scores.first!.score)! Try to beat that!"
        if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/shipdip/id1121208467?ls=1&mt=8") {
            let objectsToShare = [textToShare, myWebsite, image]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView
            let vc: UIViewController = (self.view?.window?.rootViewController!)!
            vc.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.view!.inputViewController!.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    func showLeaderBoard() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func submitHighscore(score:Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "ShipDipLeaderboard") //leaderboard id here
            scoreReporter.value = Int64(score) //score variable here (same as above)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error: NSError?) in
                if error != nil {
                    print("error")
                }
            })
        }
    }
}
