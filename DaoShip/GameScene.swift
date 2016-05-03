//
//  GameScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/6/16.
//  Copyright (c) 2016 Daniel Clark. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ship = Spaceship()
    private var motionManager =  CMMotionManager()
    private var contactMade = false
    private var destX: CGFloat?
    private var lastUpdateTime: CFTimeInterval = 0
    private var timeSinceLastLaserSpawned: CFTimeInterval = 0
    
    var score = 0
    let hsManager = HighScoreManager()
    let fnManager = FlightNoteManager()
    
    let SCENE_EDGE_CATEGORY: UInt32 = 0x1
    let LASER_CATEGORY: UInt32 = 0x2
    let SHIP_CATEGORY: UInt32 = 0x3
    let STAR_CATEGORY: UInt32 = 0x4
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        self.spawnInitialStars()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.contactTestBitMask = SHIP_CATEGORY
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.categoryBitMask = SCENE_EDGE_CATEGORY
        
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        ship.physicsBody?.dynamic = true
        ship.physicsBody?.categoryBitMask = SHIP_CATEGORY
        
        self.addChild(ship)
        
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
        let starSpeedMultiplier = CGFloat(arc4random_uniform(2) + 10)
        let parallax = SKAction.moveToY(0.0, duration: Double((0.2 * (star.position.y))/100))
        let remove = SKAction.runBlock({star.removeFromParent()})
        let replaceStar = SKAction.runBlock({self.spawnNewStar(self.size.height)})
        let sequence = SKAction.sequence([parallax, remove, replaceStar])
        self.addChild(star)
        star.runAction(sequence)
    }
    
    func spawnLaser(laserSpeed: CGFloat, laserXPosition: CGFloat) {
        let laser = Greenlaser()
        laser.physicsBody?.contactTestBitMask = SHIP_CATEGORY
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.categoryBitMask = LASER_CATEGORY
//        let laserXRange = CGFloat(arc4random_uniform(UInt32(self.size.width - ship.size.width)) + UInt32(ship.size.width/2))
        laser.position = CGPoint(x: laserXPosition, y:  self.size.height)
        self.addChild(laser)
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: laserSpeed)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //Animate ship getting screwed up here in some way
        if contact.bodyA.categoryBitMask == SHIP_CATEGORY || contact.bodyB.categoryBitMask == SHIP_CATEGORY {
            self.removeChildrenInArray([ship])
            let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
            hsManager.addNewScore(score)
            fnManager.nextNote()
            let nextScene = ReplayScene(size: scene!.size, score: score)
            nextScene.scaleMode = .AspectFill
            motionManager.stopDeviceMotionUpdates()
            scene?.view?.presentScene(nextScene, transition: transition)
       }
    }
    
    override func update(currentTime: CFTimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1.0 / 60.0
            lastUpdateTime = currentTime
        }
        
        motionManager.deviceMotionUpdateInterval = timeSinceLastUpdate
        if motionManager.deviceMotionAvailable == true {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.ship.position.x
                if data!.rotationRate.y < 0 {
                    self.destX = currentX + CGFloat(data!.rotationRate.y * 500)
                }
                    
                else if data!.rotationRate.y > 0 {
                    self.destX = currentX + CGFloat(data!.rotationRate.y * 500)
                }
                
                
            })
        }
        
        if destX != nil {
            let action = SKAction.moveToX(destX!, duration: 1)
            self.ship.runAction(action)
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        
        // If it's been more than a second since we spawned the last alien,
        // spawn a new one
        
        timeSinceLastLaserSpawned += timeSinceLastUpdate
        if (timeSinceLastLaserSpawned > 0.5) {
            timeSinceLastLaserSpawned = 0
            spawnLaser(-800, laserXPosition: ship.position.x)
            score += 1
        }
    }
}
