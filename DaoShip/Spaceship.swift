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
        let image = SKTexture(imageNamed: "gala")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.3
        yScale = 0.3
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2 - self.size.width/16)
        physicsBody?.affectedByGravity = false
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}
