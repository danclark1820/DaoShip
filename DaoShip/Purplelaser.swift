//
//  Purplelaser.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/19/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit

class Purplelaser: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        //        let constraint = SKConstraint.zRotation(zRange(constantValue: 2.0)
        let image = SKTexture(imageNamed: "Purplelaser")
        
        super.init(texture: image, color: UIColor.whiteColor(), size: image.size())
        
        xScale = 0.15
        yScale = 0.15
      
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}
