//
//  GameScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/6/16.
//  Copyright (c) 2016 Daniel Clark. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameKit
import AVFoundation
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate, GADInterstitialDelegate {
    
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
    
    var interstitial: GADInterstitial?
    
    let hsManager = HighScoreManager()
    let lastHighScore = HighScoreManager().scores.last?.score
    let tiltLabel = SKLabelNode(fontNamed: "Palatino-Roman")
    let explosionSound = SKAction.playSoundFileNamed("boom5.wav", waitForCompletion: true)
    
    
    let yellow = UIColor(red: 1.00, green: 0.96, blue: 0.57, alpha: 1.0)
    
    let SCENE_EDGE_CATEGORY: UInt32 = 0x1
    let LASER_CATEGORY: UInt32 = 0x2
    let SHIP_CATEGORY: UInt32 = 0x3
    let STAR_CATEGORY: UInt32 = 0x4
    let ASTEROID_CATEGORY: UInt32 = 0x5
    let FIRED_LASER_CATEGORY: UInt32 = 0x6
    
    override func didMoveToView(view: SKView) {
        interstitial = adMobLoadInterAd()
        
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
        scoreLabel.fontSize = 80
        scoreLabel.fontColor = yellow
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/10)
        
        tiltLabel.text = "Tilt"
        tiltLabel.name = "tiltLabel"
        tiltLabel.fontSize = 48
        tiltLabel.fontColor = yellow
        tiltLabel.position = CGPoint(x: self.frame.width/2, y: CGFloat(self.frame.height - self.frame.height/3))
        
        let rightArrow = SKLabelNode(fontNamed: "Palatino-Roman")
        rightArrow.text = ">"
        rightArrow.name = "rightArrow"
        rightArrow.fontSize = 60
        rightArrow.fontColor = yellow
        rightArrow.position = CGPoint(x: self.frame.width*(3/4), y: CGFloat(self.frame.height - self.frame.height/3))
        
        let leftArrow = SKLabelNode(fontNamed: "Palatino-Roman")
        leftArrow.text = "<"
        leftArrow.name = "leftArrow"
        leftArrow.fontSize = 60
        leftArrow.fontColor = yellow
        leftArrow.position = CGPoint(x: self.frame.width/4, y: CGFloat(self.frame.height - self.frame.height/3))
        leftArrow.hidden = false
        
        if self.hsManager.scores.first?.score == nil || self.hsManager.scores.first?.score < 6 {
            self.addChild(rightArrow)
            ArrowAction(rightArrow, pos: rightArrow.position, destX: self.frame.width)
            self.addChild(leftArrow)
            ArrowAction(leftArrow, pos: leftArrow.position, destX: 0.0)
            self.addChild(tiltLabel)
        }
        
        self.addChild(ship)
        
    }
    
    func ArrowAction(arrow: SKLabelNode, pos: CGPoint, destX: CGFloat) {
        let moveArrow = SKAction.moveToX(destX, duration: 0.60)
        let hide = SKAction.runBlock({arrow.hidden = true})
        let resetPosition = SKAction.runBlock({arrow.position = pos})
        let unhide = SKAction.runBlock({arrow.hidden = false})
        let sequence = SKAction.sequence([moveArrow, hide, resetPosition, unhide])
        let repeatSequence = SKAction.repeatAction(sequence, count: 3)
        let fadeTiltLabel = SKAction.fadeOutWithDuration(0.5)
        let hideTiltLabel = SKAction.runBlock({self.tiltLabel.runAction(fadeTiltLabel)})
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
    
    func spawnFiredLaser() {
        let laser = Greenlaser()
        laser.physicsBody?.contactTestBitMask = ASTEROID_CATEGORY
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.categoryBitMask = FIRED_LASER_CATEGORY
        laser.position = CGPoint(x: self.ship.position.x, y:  self.ship.position.y)
        laser.xScale = 0.05
        laser.yScale = 0.05
        laser.zPosition = -1
        self.addChild(laser)
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: 800)
    }
    
    func spawnAsteroid(asteroidSpeed: CGFloat, asteroidXPosition: CGFloat) {
        let asteroid = Asteroid()
        asteroid.physicsBody?.contactTestBitMask = FIRED_LASER_CATEGORY
        asteroid.physicsBody?.collisionBitMask = 0
        asteroid.physicsBody?.categoryBitMask = ASTEROID_CATEGORY
        asteroid.position = CGPoint(x: asteroidXPosition, y:  self.size.height + asteroid.size.width)
        self.addChild(asteroid)
        asteroid.physicsBody?.velocity = CGVector(dx: 0.0, dy: asteroidSpeed)
    }
    
    func spawnExplosion() {
        let explosion = Explosion()
        explosion.position = ship.position
        self.addChild(explosion)
        explosion.explode()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == LASER_CATEGORY || contact.bodyA.categoryBitMask == SCENE_EDGE_CATEGORY) && contact.bodyB.categoryBitMask == SHIP_CATEGORY {
            self.spawnExplosion()
            self.laserSpawnTime = 5.0
            self.removeChildrenInArray([contact.bodyA.node!, contact.bodyB.node!])
            self.runAction(explosionSound, completion: {
                self.transitionToReplayScene()
            })
        } else if contact.bodyA.categoryBitMask == FIRED_LASER_CATEGORY && contact.bodyB.categoryBitMask == ASTEROID_CATEGORY {
            self.removeChildrenInArray([contact.bodyA.node!, contact.bodyB.node!])
        }
    }
    
    func transitionToGameWonScene() {
        let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
        self.hsManager.addNewScore(self.score)
        
        let scene = GameWonScene(size: self.scene!.size, score: self.score)

        self.motionManager.stopDeviceMotionUpdates()
        
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func transitionToReplayScene() {
        let transition = SKTransition.fadeWithColor(self.backgroundColor, duration: 1.0)
        self.hsManager.addNewScore(self.score)
        
        let nextScene = ReplayScene(size: self.scene!.size, score: self.score)
        nextScene.scaleMode = .AspectFill
        self.motionManager.stopDeviceMotionUpdates()
        
        adMobShowInterAd()
        
        self.scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        spawnFiredLaser()
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
                } else if data!.rotationRate.y > 0 {
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
//            if score < 5 {
//                spawnFiredLaser()
                spawnAsteroid(-400, asteroidXPosition: ship.position.x)
//            } else {
//                spawnLaser(-500, laserXPosition: ship.position.x)
//            }
        
            if score == 333 && (lastHighScore < 333 || lastHighScore == nil) {
                self.transitionToGameWonScene()
            } else {
                score += 1
            }
            scoreLabel.text = String(score)
            updateLaserSpawnTime()
        }
        
        self.removeChildrenInArray([scoreLabel])
        self.addChild(scoreLabel)
    }
    
    func updateLaserSpawnTime() {
        if score == 10 {
            laserSpawnTime = 0.43
        } else if score == 20 {
            laserSpawnTime = 0.41
        } else if score == 35 {
            laserSpawnTime = 0.38
        } else if score == 50 {
            laserSpawnTime = 0.35
        } else if score == 80 {
            laserSpawnTime = 0.32
        }
    }
    
    
    func adMobLoadInterAd() -> GADInterstitial {
        print("AdMob inter loading...")
        
//        let googleInterAd = GADInterstitial(adUnitID: "ca-app-pub-1353562290522417/3485161289")
        let googleInterAd = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        
        googleInterAd.delegate = self
        
        let request = GADRequest()
        
//        request.testDevices = [kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b"] // DEBUG only
        
        googleInterAd.loadRequest(request)
        
        return googleInterAd
    }
    
    func adMobShowInterAd() {
        guard interstitial != nil && interstitial!.isReady else { // calls interDidReceiveAd
            print("AdMob inter is not ready, reloading")
            interstitial = adMobLoadInterAd()
            return
        }
        
        print("AdMob inter showing...")
        interstitial?.presentFromRootViewController((self.view?.window?.rootViewController)!)
    }

}
