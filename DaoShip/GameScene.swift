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
    
    var ship = Spaceship()
    var laser = Greenlaser()
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    var contactMade = false
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor();
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)

        self.physicsBody? = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.friction = 0
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(ship)
        
        laser.position = CGPoint(x: self.size.width/2, y: self.size.height)
        self.addChild(laser)
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: -300.0)
        
        if motionManager.accelerometerAvailable == true {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.ship.position.x
                if data?.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                } else if data?.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                }
                
            })
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in (touches) {
            //  let location = touch.locationInNode(self)
            ship.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        self.removeChildrenInArray([ship])
        contactMade = true
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        let minX = CGFloat(0.0)
        let maxX = CGFloat(self.frame.size.width)
        if self.destX > minX && self.destX < maxX{
            self.ship.position.x = self.destX
        } else if self.destX < minX {
            self.ship.position.x = minX
        } else if self.destX > maxX {
            self.ship.position.x = maxX
        }
        
        if self.laser.position.y < CGFloat(self.frame.size.height/4) {
            let newlaser = Greenlaser()
            newlaser.position = CGPoint(x: self.size.width/2, y: self.size.height)
            self.addChild(newlaser)
            newlaser.physicsBody?.velocity = CGVector(dx: 0.0, dy: -300.0)
        }
    }
}
