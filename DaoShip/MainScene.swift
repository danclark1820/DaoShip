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
    
//    override init(size: CGSize) {
//        super.init(size: size)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        playButton.text = "Play"
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/5)
        
        let intro: SKMultilineLabel?
        intro = SKMultilineLabel(text: "An ancient way of living is under siege for higher ideals. The attackers believe they are all knowing and seek to end a way of life that does not accord with their ideals. Master the way of the ship to get past the attackers. Once this done the ancient's secrets will be revealed to you.", labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/8)), name: "intro", fontName: "Palatino-Roman", leading: 22)
        intro?.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
//        intro?.border = false
//        intro?.text = "Hello World"
//        intro?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(intro!)
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
        
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
                fadeVolumeAndPause()
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
