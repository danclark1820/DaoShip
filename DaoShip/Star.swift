//
//  Star.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/31/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

import SpriteKit

class Star: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "spark")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.15
        yScale = 0.15
        
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