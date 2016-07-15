//
//  Asteroid.swift
//  ShipDip
//
//  Created by Daniel Clark on 7/14/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "asteroid")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        xScale = 0.5
        yScale = 0.5
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        physicsBody?.affectedByGravity = false
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}