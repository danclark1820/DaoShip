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
    private var timeSinceLastLaserSpawned: CFTimeInterval  = 0
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor();
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)

        self.physicsBody? = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.friction = 0
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        ship.physicsBody?.dynamic = true
        self.addChild(ship)
        
    }
    
    func spawnLaser() {
        let laser = Greenlaser()
        laser.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width)) + 1), y: self.size.height)
        self.addChild(laser)
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: -300.0)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //Animate ship getting screwed up here in some way
        self.removeChildrenInArray([ship])
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
        let nextScene = ReplayScene(size: scene!.size)
        nextScene.scaleMode = .AspectFill
        motionManager.stopDeviceMotionUpdates()
        scene?.view?.presentScene(nextScene, transition: transition)
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
        if (timeSinceLastLaserSpawned > 1.0) {
            timeSinceLastLaserSpawned = 0
            spawnLaser()
        }
    }
}
