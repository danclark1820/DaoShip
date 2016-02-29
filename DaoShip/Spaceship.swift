//
//  Spaceship.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/21/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "Spaceship")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.55
        yScale = 0.40
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/4)
        physicsBody?.affectedByGravity = false
        physicsBody?.collisionBitMask = 1
        physicsBody?.categoryBitMask = 0
        physicsBody?.contactTestBitMask = 1
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}
