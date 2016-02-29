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
    
    var sprite = Spaceship()
    var laser = Greenlaser()
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor();
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)

//        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        borderBody.friction = 0

        self.physicsBody? = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.friction = 0
        
        sprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(sprite)
        
        laser.position = CGPoint(x: self.size.width/2, y: self.size.height)
        self.addChild(laser)
        laser.physicsBody?.velocity = CGVector(dx: 0.0, dy: -300.0)
        
        
        if motionManager.accelerometerAvailable == true {
            // 2
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.sprite.position.x
                // 3
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
            sprite.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print(self.frame.width)
        print(self.frame.height)
        self.removeChildrenInArray([sprite])
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        let minX = CGFloat(0.0)
        let maxX = CGFloat(self.frame.size.width)
        if self.destX > minX && self.destX < maxX{
            self.sprite.position.x = self.destX
        }
    }
}
