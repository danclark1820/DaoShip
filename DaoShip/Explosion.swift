//
//  Explosion.swift
//  ShipDip
//
//  Created by Daniel Clark on 6/9/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

import SpriteKit

class Explosion: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "spark")
        
        super.init(texture: image, color: UIColor(red:0.05, green:1.00, blue:0.00, alpha:1.0), size: image.size())
        colorBlendFactor = 1
        alpha = 1
        xScale = 10
        yScale = 7
        zPosition = 2
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
}