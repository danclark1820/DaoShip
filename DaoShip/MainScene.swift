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
    
//    private var ship = Spaceship()
//    private var motionManager =  CMMotionManager()
//    private var contactMade = false
//    private var destX: CGFloat?
//    private var lastUpdateTime: CFTimeInterval = 0
//    private var timeSinceLastLaserSpawned: CFTimeInterval = 0
//    private var shipSpeedMultiplier = 500.0
//    
//    let SHIP_CATEGORY: UInt32 = 0x3
//    let SCENE_EDGE_CATEGORY: UInt32 = 0x1
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        
        playButton.text = "Play"
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        playButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
//        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
//        
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        self.physicsBody?.contactTestBitMask = SHIP_CATEGORY
//        self.physicsBody?.collisionBitMask = 0
//        self.physicsBody?.categoryBitMask = SCENE_EDGE_CATEGORY
//        
//        
//        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
//        ship.physicsBody?.dynamic = true
//        ship.physicsBody?.categoryBitMask = SHIP_CATEGORY
        
        self.addChild(playButton)
//        self.addChild(ship)
        self.spawnInitialStars()
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
//                motionManager.stopDeviceMotionUpdates()
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
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
//        var timeSinceLastUpdate = currentTime - lastUpdateTime
//        lastUpdateTime = currentTime
//        if timeSinceLastUpdate > 1.0 {
//            timeSinceLastUpdate = 1.0 / 60.0
//            lastUpdateTime = currentTime
//        }
//        
//        motionManager.deviceMotionUpdateInterval = timeSinceLastUpdate
//        if motionManager.deviceMotionAvailable == true {
//            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
//                data, error in
//                
//                let currentX = self.ship.position.x
//                if data!.rotationRate.y < 0 {
//                    self.destX = currentX + CGFloat(data!.rotationRate.y * self.shipSpeedMultiplier)
//                }
//                    
//                else if data!.rotationRate.y > 0 {
//                    self.destX = currentX + CGFloat(data!.rotationRate.y * self.shipSpeedMultiplier)
//                }
//                
//                
//            })
//        }
//        
//        if destX != nil {
//            let action = SKAction.moveToX(destX!, duration: 1)
//            self.ship.runAction(action)
//        }
    }
}
