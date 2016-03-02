//
//  Greenlaser.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/21/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit

class Greenlaser: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        //        let constraint = SKConstraint.zRotation(zRange(constantValue: 2.0)
        let image = SKTexture(imageNamed: "Greenlaser")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.15
        yScale = 0.15
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width, height: self.size.height))
        physicsBody?.affectedByGravity = false
        physicsBody?.collisionBitMask = 0
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 1
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}
