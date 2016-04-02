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
        
        super.init(texture: image, color: UIColor.yellowColor(), size: image.size())
        colorBlendFactor = 0.4
        alpha = randomBetweenNumbers(0.4, secondNum: 1)
        let starScale = randomBetweenNumbers(0.0, secondNum: 0.3)
        xScale = starScale
        yScale = starScale
        
    }
    
    convenience init() {
        self.init(texture: nil, color: nil, size: CGSizeZero)
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init coder had not been implementted")
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}