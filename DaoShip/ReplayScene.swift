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
        "The best captain, the crew do not know they have a captain. The next best is loved by his crew. The next best is feared by his crew. When the captain does not trust his crew, and the crew becomes dishonest.",
        "The master pilot captains with action and not words. When the job is done, the crew says, “We did it!”",
        "When the way of the ship is forgotten, morals and righteousness are born. When crew is tired, they attempt to be clever. When there is no peace in the family, parents are honored in a resentful manner. When people are confused, they are loyal, but don’t know why. This is a great misfortune.",
        "Giving up trying to be knowledgeable, the crew is hundreds times happier. Giving up morals and rightousness, the crew naturally acts in line with the way. Throwing away desires for gains and profits, and there are no thieves in this space age.",
        "If leading the crew in this fashion still does not keep the peace, hold on to simplicity, act for the crew, and decrease selfish desires, and let ship take its course.",
        "Give up thinking and end your confusion and distress. What is the difference between the prosperity and the poverty? What is the difference true and false. There is no need to live in the shadow of others desires. There is no reason to fear what others fear.",
        "Other people get excited like they are at a great party. I am relaxed and as excited as quite evening. Others have goals and no exactly where they are going, while I drift like a wave on the ocean.",
        "Never intoxicated by the moment or cultural expectations, I am able to fly through life effortlessly, like the wings of the ship gliding on the atmosphere heading down for a smooth landing. I follow the way of the ship.",
        "The master pilot follows the way of the ship wherever it leads. The way of the ship as a physical thing seems confusing.",
        "How can the master pilots follow it if it is not physical thing? Because they do not look for it or try to hold it, they listen to there intuition and move on.",
        "How can the master pilots use there intuition to follow something so confusing when explained with words whose depths are unknown? Because they let there intuition do the work and do not overthink things or future outcomes.",
        "Since before the big bang, before traversable space, and before physical ships, there was the way of the ship. It is more then being and not being. How do we know this to be true? Through our intuition as pilots to get in our ships and fly.",
        "The fill something up it must be empty first. To straighten something out it must be bent first. To make something soft it must stiff first. Many desires will be hard can to fulfill. Fewer the desires, the easier they are to fulfill.",
        "Therefore a master is always humble. A master spreads humbleness. Because they do not brag, they are viewed as accomplished. Have nothing to brag about, people believe everything they say. Because they are not exactly sure who they are, others can relate to them on the deepest level.",
        "With no end point in mind, the master is always exactly at their destination. Without a target, the pilot always hits the mark. Without a plan, everything the pilot pursues is executed exactly as planned. Because success is not a future ambition, it is a present state.",
        "Say what you know to be true then listen. A summer rain does not rain all day, a winter storm does not last all winter. This is being like nature. Knowing in your heart of hearts that the ship has its way, it will reveal itself to you, and your intuition will become stronger.",
        "Standing on tiptoes we become un-sturdy. Outstretched arms cannot hold on for long. Brag and boasting only shows what you are lacking. Letting titles define you, you cannot know who you really are. If you want to be one with the ship, just help your crew, then step back.",
        "What was before the big bang? What could have governed such a tightly packed ball of matter followed by the most violent explosion in all of known time. We cannot know for sure, but for simplicity we call it the way of the ship.",
        "It is a part of all things, physical and non-physical. It is in the walls as well as the empty space that allow us to call the walls and its inner volume a room. There at the begging when the universe was smaller then a speck of dust, it spreads out with the universe as it expands.",
        "Man, earth, the sun, the universe, and the way of the ship are all great. Man follows the earth, earth follows, the sun, sun follows the galaxy, galaxy follows the universe, universe follows the way of the ship.",
        "Light ships have heavy engines. The pilot travels all day through space without going far. While the views of far off stay systems are pleasant, he is happy in his cockpit on his present mission.",
        "Why should the master pilot fly around on endless missions. If you let yourself be signed up for every mission, you will lose a sense of what missions matter most to you. If your desire for grander mission interrupts your present one, you will never complete one.",
        "A good pilot has no fixed route. A good mechanic does not assume he knows what wrong with the engine. A good ship designer lets the present state of ships guide his next design.",
        "The master pilot can and will discuss the ship with anyone who asks, ship lovers and ship haters.  He is ready for all challenges the ship and future missions present. By doing this, the pilot embodies the way of the ship.",
        "A good pilot is bad pilots teacher. A bad pilot is a good pilots job. A student that does not love their teacher, or a teacher who does not learn from there student is completely lost, however smart they are. This is the great secret of the ship.",
        "Understand what parts of the ship are masculine, but focus on the female. Hold the immensity of the ship inside you. If you do this, the way of the ship will be strong inside you, and the ship will give you the joy a child gets when seeing a ship for the first time.",
        "Understanding the light but keeping to the dark. The pilot is a role model for future pilots. Being a role model the for future pilots, the way of the ship will always creates virtue within the pilot.",
        "The ship is formed from metal parts. Metal parts are formed from metal blocks. Understanding the parts remembering they came from blocks the pilot understands the ship. The master pilot knowing this, can help all in there journey to understand the ship.",
        "Trying to control the universe will only end in failure. It is not an object to be held or molded.",
        "It is the way of the universe that what is ahead will be behind, what is hot, will cool down,  what is strong, eventually weakens. The master pilot sees ship and the universe for how it is and does not try to control it. The master lets them go there way and does not over exert themselves.",
        "The master pilot who relies on the way of the ship for leading his crew does not fight with his men, or capture enemies by way of force. Every action creates an equal and opposite reaction. Force, even for good, will always come back to the master or his crew.",
        "The master pilot does his work then rests. The master knows the universe is beyond a pilots control, and forcing events will lead to failure.",
        "The pilot believes in their ability, and does not need to persuade the crew. The pilot knows themselves, and does not need the publics acceptance. The pilot loves themselves as they love others, so the universe loves them.",
        "The ships weapons can only be involved in battle, and the pilot prefers to never use them.",
        "The master pilot avoids the use of weapons at all costs. When it does become an absolute, the weapons are used with heavy hearts, and utter respect for there destructiveness. The master does not celebrate victory because pilots on both sides have fallen.",
        "The master pilots enemies are just other pilots, not evil men. While they may have lost there way, they are seen as pilots, and the pilot does not wish to hurt them.",
        "The way of the ship is name for something that cannot be named. If leaders of our galaxies are at one with the way of the ship, there would be intergalactic peace. There would be no need for laws becuase people would act based on good natured intuition.",
        "What part of the ship is ship? Is the engine the ship, is the cockpit the ship? When we have names for things, understand that names are just that. Understand what is underneath and its purpose, understand where the name ends.",
        "The pilot who knows other people is compassionate. The pilot who knows themself is wise.  Being able to help others is couragous.  Being able to help oneself is a daily battle that can end in daily victory.",
        "Knowing that you have enough, you become wealthy. Acting with lots of energy is the way to strengthening your will. Completing the days tasks are what lead to longevity. Embracing the bodies inevitable end, you can never die.",
        "The way of the ship flows in all ships and pilots. All ships were created from it, yet it does not claim the ships as a possesion. It is visible the smallest nut or bolt of the ship, in there interlocking perfection, but it is also in the whole ship, when it takes graceful flight.",
        "Hence the master pilot pays just as much attention too the small things as the great things. Great acheivment comes from the pilots ability to focus on small not great acheivements that are built upon daily.",
        "At one with the ship the pilot can travel through even the most dangerous of galaxies. Everyone is at ease in the company of a master pilot.",
        "Planetary festivals and their many tasty foods are exciting, while the words that describe the way of the ship are boring and bland. It cannot be seen or heard, but when used, it is endless source of inspiration.",
        "Before letting a crew member know they have done something incorrectly, let them know they have done something correct. Before winning a battle, the master lets the enemy believe they are winning. This is how the master achieves without dominating or boasting.",
        "Soft and weak over time overcomes what appears to be strong and tough. Let the methodology remain a mystery and just show citizens your achievement.",
        "The way of the ship is never doing anything, yet though it the ship endures.  If leaders could center themselves in the way of the ship the whole universe would be transformed. Through simplicity, non-desire, stillness, the universe corrects itself.",
        "Master pilots do not try to control, hence they are always in control. The average person always trying to control feels helplessly out of control. The master pilot does plan, yet everything is done on time. The average person always planning, never gets things done in time.",
        "The man looking to fix the world makes a plan. The man looking to make the world moral speaks loudly to deaf audiences. The man looking to bring justice to all, often ends up using violence. Thus the way of the ship is lost when we strive for control. Only act when the moment presents itself.",
        "When the way of the ship is gone, the men make plans, when the plans are lost, morality kicks in, when morality is lost, justice must be served, when justice is served, there is violence. Hence, the master focuses solely on the reality of a present scenario, and not the dogma of words and rules.",
        "The way of the ship is what lets the stars shine, the night be dark, the day be bright and the motion be perfect amongst the stars and planets.  Stars have no desire to shine, the day no desire to come, the planets no desire to move. They just are. The master is humble as a stone.",
        "Returning is the movement of the way. Things done over time through soft action are the markings the way of the ship at work. All objects are created into being. Being is created from non-being.",
        "When the best pilots heard of way of the ship for the first time, they immediatley put it to use in there life. The average pilots used it hear and there but not with dilligence.  Lower pilots when they hear of the way of the ship they laugh, if they did not laugh it would not be the way.",
        "So the clear way of the ship seems unclear. Understanding of the ship can look like confusion. The ships high integrity comes from low places. The path to the light is dark. What makes the ship beautiful seems ugly. Its simplicity, comes from complexity.",
        "The way of the ship cannot be found, but it is what makes the ship the ship.",
        "The way of the ship created the one. One created Two. Two created Three. Three created all things. All things come from the many to and move towards embracing the way of the ship. When the many things combine to be one with the way of the ship, there is peace.",
        "Average people are lonely. The master pilot sees alone time as an oppurtunity. Appear to lose and win, Appear to win, but lose. The violent and strong pilots do not die a natural death.",
        "The softest thing in world, weakens the hardest thing in world. Streams of water break down mountains, gamma rays penetrate the ships hard exterior. That which has no physical matter, enters where there is no physical space.",
        "This is the beauty of teaching without words. The beauty of accomplishment without action. Unattached to the end, the master pilot succeeds."
        ]
}
