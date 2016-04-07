//
//  ReplayScene.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/3/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import SpriteKit
import Darwin

class ReplayScene: SKScene {
    
    let lastScore: Int?
    
    init(size: CGSize, score: Int) {
        lastScore = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let hsManager = HighScoreManager()
    let fnManager = FlightNoteManager()
    var noteNumber: Int?

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = UIColor.blackColor()
        let lastScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let highScoreLabel = SKLabelNode(fontNamed: "Palatino-Roman")
        let playButton = SKLabelNode(fontNamed:"Palatino-Roman")
        
        
        if fnManager.notes.last == nil {
            noteNumber = 0
        } else {
            noteNumber = fnManager.notes.last!.number
        }
        
        let flightNoteLabel: SKMultilineLabel?
        if noteNumber > notes.count {
            flightNoteLabel = SKMultilineLabel(text: "Your training is complete", labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/5)), fontName: "Palatino-Roman", leading: 22)
        } else {
            flightNoteLabel = SKMultilineLabel(text: notes[noteNumber!], labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/5)), fontName: "Palatino-Roman", leading: 22)
        }
        
        
        let cropNode = SKCropNode()
        cropNode.zPosition = 1
        let barPosition = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(self.frame.height/3))
        let alphaBarNode = Purplelaser()
        alphaBarNode.alpha = 0.2
        alphaBarNode.position = barPosition
        let barNode = Purplelaser()
        barNode.position = barPosition
        barNode.name = "bar"
        
        let mask = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(barNode.frame.size.width, barNode.frame.size.height))
        mask.position = CGPoint(x: (barNode.position.x - barNode.frame.size.width/2), y: (barNode.position.y))
        cropNode.addChild(barNode)
        cropNode.maskNode = mask
        
        lastScoreLabel.text = "Previous: " + String(lastScore!)
        lastScoreLabel.name = "scoreLabels"
        lastScoreLabel.fontSize = 20
        lastScoreLabel.position = CGPoint(x: (0.0 + lastScoreLabel.frame.width/2), y: (self.frame.height - lastScoreLabel.frame.height))
        
        highScoreLabel.text = "High: " + String(self.hsManager.scores.first!.score)
        highScoreLabel.name = "scoreLabels"
        highScoreLabel.fontSize = 20
        highScoreLabel.position = CGPoint(x: (self.frame.width - highScoreLabel.frame.width/2), y: (self.frame.height - highScoreLabel.frame.height))
        
        playButton.text = "Continue"
        playButton.name = "playButton"
        playButton.fontSize = 30
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/6)
        
        self.addChild(flightNoteLabel!)
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
        self.addChild(playButton)
        self.addChild(alphaBarNode)
        self.addChild(mask)
        self.addChild(cropNode)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButton" {
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }

        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    let notes = [
        "Welcome to the Ship, I am master Tzu, as you embark on your journey I will offer notes of guidance to help you understand the way of your ship, the universe and your journey. Collect all the notes and you will be a master pilot like me.",
        "Just as the name of your ship is not the actual ship, so too are these words not the actual way. They are more like an intergalactic road sign, focus too hard on the sign, and you’ll surely miss the turn.",
        "Because there are fast ships, it means there a slow ships. Because there small ships, it means there are big ships. Neither one is wrong, it is just the nature of the universe.",
        "The master pilot flies without thinking or trying, flying solely on intuition. He leads his crew by example and not by words or force.",
        "Understanding of the ship may seem attainable, but the more the master pilot understands, the more the pilot realizes his lack of understanding. That is why the ship is infinite. The way of the ship existed long before the ship itself.",
        "The ship does not take sides with good or evil, it is just a ship. Therefore the master pilot sees other ships and pilots not as good or evil, but merely the way of the ship in persons, places and things.",
        "The way of the ship is present in all ships. It is not a physical thing, but it is always there, for the pilot, or the ship builder, or the mechanic to use on their journey to understand the ship. The way of the ship is in you and available whenever needed.",
        "The ship was never born, thus can never die, and certainly does not care about itself. Therefore the master pilot just goes about being a pilot, without trying to survive, or achieve. By doing this, the pilot survives and achieves.",
        "The ship travels to undesirable locations as easily as desirable ones. The master pilot flies with grace but still cleans the space toilet.",
        "In living, be close to your ship. In dealing with others, see them as future pilots learning the way. In speaking about the ship, stick to what you know to be true. In leading your crew, never try to control. In flying, enjoy every subtle turn or dip.",
        "Because the master pilot and great ship do not seek respect or honors, they are always given. Being content to be the pilot you were born to be, not comparing yourself to other pilots, you will always succeed.",
        "Fill the cargo bay to the brim and there will be no room in the cockpit. Continually upgrading the propolsion system and leads to engine failure. Treasures aboard the ship attract space pirates. Many honors lead to cockiness, setting one self up for failure.",
        "When the mission is completed, the master pilot goes home to his family and friends, which is the greatest reward.",
        "Can your inner pilot embrace the oneness of your ship with the universe. Forgetting about the desire, glory, the physical state of your ship, can you be the infinitely capable pilot. Can you fly with grace and joy of child flying for the first time.",
        "Can your inner pilot lead the crew with out forcing your intention. Can one pilot lead many with out corruption. Can one land the ship with the gentle touch of a female. Can one forget about flight school and understand the way of the ship and how to fly it.",
        "Showing young pilots the way, achieving without receiving, leading without force, flying without trying, this is the way of the ship.",
        "We make large cargo bays in our steel ships, but its the empty space that leaves room for cargo. Comfy seats are put in cockpit, but the space for the pilot is what makes the ship flyable. The propulsion system surely would not work if there was not space for the fuel to burn.",
        "We use precious metals for our ship, but it is the empty space that makes it useful. Seek the empty space that make ship useful, and not the precious metal that composes it.",
        "Great triumph is as toxic as great failure. It is important, no matter what the circumstances, to remain grounded and humble. Obsession with progress and fear of failure are identical and are a result focusing on the self and not the whole mission.",
        "Love the universe as you do yourself, have trust in the way it is and then you can see all things for what they really are.",
        "Search, it cannot be found. Ear to the ground it, it cannot be heard. Grasp for it, it cannot be held. Sitting before the sun it makes no shadow. It is unnamable, intangible, shapeless, colorless, the way of the ship is nothing.",
        "We come face to face with the way of the ship and it has no front, we follow it but it has no back. It is nothing, yet when we let the way of the ship take its course, no mission can fail, this is flying and the way of a true pilot.",
        "The pilots of ancient times flew through the universe in unfathomable ways. We can describe it, but it does not do it justice.",
        "Always hesitant, as if approaching a new planet of an unknown surface. Always cautious, as if entering an asteroid belt. Always humble as guest in a foreign galaxy. Always adaptable to whatever the universe presented, like a crew member looking to help.",
        "Do you have the patience of the ancient pilot. Do you know how to let gravity do the work when navigating the universe. Can you sit still and wait for proper moment to arise before taking action.",
        "The pilots of ancient did not seek change and achievement, they let it come to them. When the oppurtunity for a mission arose, they took it, helping the universe take its course. But they were not mission seekers.",
        "The mind can be emptied of all distractions. Bring the heart to its resting rate. The frustration you see in others is self imposed and temporary. Accomplished or unaccomplished we return to the resting state. Returning to the resting state is peace.",
        "Knowing the resting state we can always return to it. The resting state is the source of all energy. Not knowing the resting state leads to frustration and untimely action. Knowing the resting state, you can see the universe as whole, and be in awe of the way of the ship.",
        "Knowing the resting state, the universe as whole, and the way of the ship, one can proceed without fear and even welcome death.",
        ]
}
