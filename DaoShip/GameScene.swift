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
    private var laserSpawnTime = 0.45
    private var shipSpeedMultiplier = 500.0
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
    
    let hsManager = HighScoreManager()
    let tiltLabel = SKLabelNode(fontNamed: "Palatino-Roman")
    
    let SCENE_EDGE_CATEGORY: UInt32 = 0x1
    let LASER_CATEGORY: UInt32 = 0x2
    let SHIP_CATEGORY: UInt32 = 0x3
    let STAR_CATEGORY: UInt32 = 0x4
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.11, alpha: 1.0)
        self.spawnInitialStars()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.contactTestBitMask = SHIP_CATEGORY
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.categoryBitMask = SCENE_EDGE_CATEGORY
        
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        ship.physicsBody?.dynamic = true
        ship.physicsBody?.categoryBitMask = SHIP_CATEGORY
        
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/10)
        
        
        tiltLabel.text = "Tilt"
        tiltLabel.name = "tiltLabel"
        tiltLabel.fontSize = 48
        tiltLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        tiltLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/5)
        
        let rightArrow = SKLabelNode(fontNamed: "Palatino-Roman")
        rightArrow.text = ">"
        rightArrow.name = "rightArrow"
        rightArrow.fontSize = 60
        rightArrow.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        rightArrow.position = CGPoint(x: self.frame.width*(3/4), y: self.frame.height/5)
        
        self.addChild(rightArrow)
        ArrowAction(rightArrow, pos: rightArrow.position, destX: self.frame.width)
        
        let leftArrow = SKLabelNode(fontNamed: "Palatino-Roman")
        leftArrow.text = "<"
        leftArrow.name = "leftArrow"
        leftArrow.fontSize = 60
        leftArrow.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.83, alpha: 1.0)
        leftArrow.position = CGPoint(x: self.frame.width/4, y: self.frame.height/5)
        leftArrow.hidden = false
        
        self.addChild(leftArrow)
        ArrowAction(leftArrow, pos: leftArrow.position, destX: 0.0)
        
        self.addChild(tiltLabel)
        self.addChild(ship)
        
    }
    
    func ArrowAction(arrow: SKLabelNode, pos: CGPoint, destX: CGFloat) {
        let moveArrow = SKAction.moveToX(destX, duration: 0.60)
        let hide = SKAction.runBlock({arrow.hidden = true})
        let resetPosition = SKAction.runBlock({arrow.position = pos})
        let unhide = SKAction.runBlock({arrow.hidden = false})
        let sequence = SKAction.sequence([moveArrow, hide, resetPosition, unhide])
        let repeatSequence = SKAction.repeatAction(sequence, count: 3)
        let hideTiltLabel = SKAction.runBlock({self.tiltLabel.hidden = true})
        let finalSequence = SKAction.sequence([repeatSequence, hide, hideTiltLabel])
        arrow.runAction(finalSequence)
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
        laser.position = CGPoint(x: laserXPosition, y:  self.size.height)
        self.addChild(laser)
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: laserSpeed)
    }
    
    func spawnExplosion() {
        let explosion = Explosion()
        explosion.position = ship.position
        self.addChild(explosion)
//        let explode = SKAction.scaleTo(0.25, duration: 0.5)
//        explosion.runAction(explode)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //Animate ship getting screwed up here in some way
        if contact.bodyA.categoryBitMask == SHIP_CATEGORY || contact.bodyB.categoryBitMask == SHIP_CATEGORY {
            self.spawnExplosion()
            self.removeChildrenInArray([contact.bodyA.node!, contact.bodyB.node!])
            let transition = SKTransition.fadeWithDuration(2.0)
            transition.pausesIncomingScene = true
            hsManager.addNewScore(score)
            
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
                    self.destX = currentX + CGFloat(data!.rotationRate.y * self.shipSpeedMultiplier)
                }
                    
                else if data!.rotationRate.y > 0 {
                    self.destX = currentX + CGFloat(data!.rotationRate.y * self.shipSpeedMultiplier)
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
        timeSinceLastLaserSpawned += timeSinceLastUpdate
        if (timeSinceLastLaserSpawned > laserSpawnTime) {
            timeSinceLastLaserSpawned = 0
            spawnLaser(-800, laserXPosition: ship.position.x)
            score += 1
            scoreLabel.text = String(score)
            updateLaserSpawnTimeAndShipSpeed()
        }
        
        self.removeChildrenInArray([scoreLabel])
        self.addChild(scoreLabel)
    }
    
    func updateLaserSpawnTimeAndShipSpeed() {
        if score == 10 {
            laserSpawnTime = 0.43
            shipSpeedMultiplier = 540
        } else if score == 20 {
            laserSpawnTime = 0.41
            shipSpeedMultiplier = 580
        } else if score == 35 {
            laserSpawnTime = 0.38
            shipSpeedMultiplier = 620
        } else if score == 50 {
            laserSpawnTime = 0.35
            shipSpeedMultiplier = 680
        } else if score == 80 {
            laserSpawnTime = 0.32
            shipSpeedMultiplier = 720
        }
    }
}
