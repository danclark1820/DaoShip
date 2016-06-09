//
//  Explosion.swift
//  ShipDip
//
//  Created by Daniel Clark on 6/8/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

import SpriteKit

class Explosion: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "spark")
        
        super.init(texture: image, color: UIColor.orangeColor(), size: image.size())
        alpha = 1
        xScale = 1.0
        yScale = 1.0
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
    
}