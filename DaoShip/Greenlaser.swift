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
        let image = SKTexture(imageNamed: "Greenlaser")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.15
        yScale = 0.15
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width/3, height: self.size.height - self.size.height/8))
        physicsBody?.affectedByGravity = false
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}
