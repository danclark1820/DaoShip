//
//  MainScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/11/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//


import SpriteKit
import CoreMotion
import AVFoundation

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    private var ship = Spaceship()
    var audioPlayer: AVAudioPlayer?
    
    let tapLabel = SKLabelNode(fontNamed: "Palatino-Roman")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        playButton.text = "Play"
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/5)

        
//
//        let introLabel3 = introLabel("Master the way of the ship to get past the attackers. Once this done the ancient's secrets will be revealed to you.", name: "introLabel3")
        
//        addIntroLabel(introLabel1)
//        addIntroLabel(introLabel2)
//        addIntroLabel(introLabel3)
//        self.addChild(introLabel1)
//        introLabel1.runAction(SKAction.fadeOutWithDuration(2.5))
//        introLabel1.update()
        
        tapLabel.position = CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/3))
        tapLabel.text = "Tap Here"
        tapLabel.name = "tapLabel"
        tapLabel.fontSize = 45
        tapLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        tapLabel.alpha = 1.0
        self.addChild(tapLabel)
        
        self.addChild(playButton)
        self.addChild(ship)
        self.spawnInitialStars()
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)
        
        let audioURL = NSBundle.mainBundle().URLForResource("ShipDipTheme", withExtension: "m4a")!
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("audioPlayer failure")
        }
        
        self.play()
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let introLabel1 = self.introLabel("An ancient way of living is under siege for higher ideals...", name: "introLabel1")
        introLabel1.shouldShowBorder = true
        let introLabel2 = self.introLabel("The attackers believe they are all knowing and seek to end a way of life that does not accord with their ideals.", name: "introLabel2")
        
        
//        introLabel1.runAction(SKAction.fadeOutWithDuration(2.5))
//        self.addChild(introLabel1)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "tapLabel" {
                self.rotateShip()
                tapLabel.runAction(SKAction.fadeOutWithDuration(0.75), completion: {
                    self.addChild(introLabel1)
                    self.tapLabel.removeFromParent()
                    print("\(introLabel1.name) <<<<<<<<<<<<")
                })
            } else if touchedNode.parent?.name== "introLabel1" {
                self.rotateShip()
                introLabel1.runAction(SKAction.fadeOutWithDuration(0.75), completion: {
                    introLabel1.update()
                    self.addChild(introLabel2)
                    introLabel1.removeFromParent()
                })
            } else if touchedNode.name == "playButton" {
                fadeVolumeAndPause()
                let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
                transition.pausesOutgoingScene = false
                transition.pausesIncomingScene = true
                
                self.rotateShip()
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }

    }
    
    func rotateShip() {
        let rotateShip = SKAction.rotateByAngle( 2.0*CGFloat(M_PI), duration: 0.05)
        let repeatAction = SKAction.repeatAction(rotateShip, count: 5)
        ship.runAction(repeatAction)
    }
    
//    "An ancient way of living is under siege for higher ideals. The attackers believe they are all knowing and seek to end a way of life that does not accord with their ideals. Master the way of the ship to get past the attackers. Once this done the ancient's secrets will be revealed to you."
    
    func introLabel(note: String, name: String) -> SKMultilineLabel {
        var intro: SKMultilineLabel?
        intro = SKMultilineLabel(text: note, labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/4)), name: "WhyDoesntThisGetSetHere", fontName: "Palatino-Roman", leading: 24)
        intro!.dontUpdate = false
        intro!.name = name
        intro!.alpha = 1.0
        intro!.update()
        return intro!
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
    
    override func update(currentTime: CFTimeInterval) {

    }
}
