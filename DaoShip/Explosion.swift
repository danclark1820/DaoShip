//
//  Explosion.swift
//  ShipDip
//
//  Created by Daniel Clark on 6/10/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation
import SpriteKit

class Explosion: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor?, size: CGSize ){
        let image = SKTexture(imageNamed: "spark")
        
        super.init(texture: image, color: UIColor(red:0.30, green:1.00, blue:0.30, alpha:1.0), size: image.size())
        colorBlendFactor = 1
        alpha = 0.9
        xScale = 0.25
        yScale = 0.25
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
    
    func explode() {
        self.runAction(SKAction.scaleXTo(16.0, duration: 0.15))
        self.runAction(SKAction.scaleYTo(12.0, duration: 0.15))
    }
}