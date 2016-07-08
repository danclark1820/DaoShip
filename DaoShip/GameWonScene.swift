//
//  GameWonScene.swift
//  ShipDip
//
//  Created by Daniel Clark on 7/5/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameWonScene: SKScene {
    
    private var ship = Spaceship()
    var audioPlayer: AVAudioPlayer?
    let yellow = UIColor(red: 1.00, green: 0.96, blue: 0.57, alpha: 1.0)
    let blue = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)
    let lastScore: Int
    let conLabel = SKLabelNode(fontNamed: "Palatino-Roman")
    let hsManager = HighScoreManager()
    
    init(size: CGSize, score: Int) {
        lastScore = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.spawnInitialStars()
        
        conLabel.position = CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/3))
        conLabel.text = "Congratulations!"
        conLabel.name = "conLabel"
        conLabel.fontSize = 45
        conLabel.fontColor = yellow
        conLabel.alpha = 1.0
        
        self.backgroundColor = blue
        
        
        let audioURL = NSBundle.mainBundle().URLForResource("ShipDipTheme", withExtension: "m4a")!
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("audioPlayer failure")
        }
        
        self.play()
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        self.addChild(ship)
        self.addChild(conLabel)
    }
    
    func introLabel(note: String, name: String) -> SKMultilineLabel {
        var intro: SKMultilineLabel?
        intro = SKMultilineLabel(text: note, labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/4)), name: "WhyDoesntThisGetSetHere", fontName: "Palatino-Roman", leading: 28)
        intro!.dontUpdate = false
        intro!.name = name
        intro!.alpha = 1.0
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
        star.alpha = 1.0
        let starXRange = CGFloat(arc4random_uniform(UInt32(self.size.width)))
        star.position = CGPoint(x: starXRange, y: yPosition)
        self.addChild(star)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let note1 = introLabel("Your dilligence has shown mastery of the ship.", name: "note1")
        let note2 = introLabel("The ancients secret is now yours to have...", name: "note2")
        let note3 = introLabel("But, you already discovered it along your way past the attackers.", name: "note3")
        let note4 = introLabel("It is that the way, your way, is always right in front of you...", name: "note4")
        let note5 = introLabel("You just have to follow it.", name: "note5")
        
        if let location = touches.first?.locationInNode(self) {
            
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "conLabel" {
                conLabel.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    self.conLabel.removeFromParent()
                    self.addChild(note1)
                })
            } else if touchedNode.parent?.name == "note1" {
                self.childNodeWithName("note1")!.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    note1.removeFromParent()
                    self.addChild(note2)
                })
            } else if touchedNode.parent?.name == "note2" {
                self.childNodeWithName("note2")!.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    note2.removeFromParent()
                    self.addChild(note3)
                })
            } else if touchedNode.parent?.name == "note3" {
                self.childNodeWithName("note3")!.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    note3.removeFromParent()
                    self.addChild(note4)
                })
            } else if touchedNode.parent?.name == "note4" {
                self.childNodeWithName("note4")!.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    note4.removeFromParent()
                    self.addChild(note5)
                })
            } else if touchedNode.parent?.name == "note5" {
                self.childNodeWithName("note5")!.runAction(SKAction.fadeOutWithDuration(0.5), completion: {
                    note5.removeFromParent()
                    let sequence = SKAction.sequence([SKAction.scaleBy(4.0, duration: 0.5), SKAction.moveToY((self.frame.height + 2*self.ship.size.height), duration: 0.5), SKAction.removeFromParent()])
                    self.ship.runAction(sequence, completion: {
                        self.fadeVolumeAndPause()
                        self.transitionToReplayScene()
                    })
                })
            }
        }
    }
    
    func transitionToReplayScene() {
        let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
        self.hsManager.addNewScore(self.lastScore)
        
        let nextScene = ReplayScene(size: self.scene!.size, score: self.lastScore)
        nextScene.scaleMode = .AspectFill
        self.scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
}