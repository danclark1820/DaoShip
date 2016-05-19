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
        let playButton = SKLabelNode(fontNamed: "Palatino-Roman")
        let flightNoteCount = SKLabelNode(fontNamed: "Palatino-Roman")
        
        let notesCount = notes.count
        flightNoteCount.text = String(fnManager.notes.last!.number) + "/" + String(notesCount)
        flightNoteCount.name = "flightNoteCount"
        flightNoteCount.fontSize = 20
        
        
        
        if fnManager.notes.last == nil {
            noteNumber = 0
        } else {
            noteNumber = fnManager.notes.last!.number
        }
        
        let flightNoteLabel: SKMultilineLabel?
        if noteNumber > notes.count {
            flightNoteLabel = SKMultilineLabel(text: "Your training is complete", labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/3)), name: "flightNoteLabel", fontName: "Palatino-Roman", leading: 22)
            self.addChild(flightNoteLabel!)
            flightNoteLabel!.name = "flightNoteLabel"
            flightNoteCount.position = CGPoint(x: CGRectGetMidX(self.frame), y: flightNoteLabel!.pos.y + CGFloat(flightNoteLabel!.labelHeight/2))
            self.addChild(flightNoteCount)
        } else if lastScore < 20 {
            self.addChild(playButton)
        } else {
            flightNoteLabel = SKMultilineLabel(text: notes[noteNumber!], labelWidth: Int(self.frame.width - self.frame.width/8), pos: CGPoint(x: Int(self.frame.width/2) , y: Int(self.frame.height - self.frame.height/3)), name: "flightNoteLabel", fontName: "Palatino-Roman", leading: 22)
            self.addChild(flightNoteLabel!)
            flightNoteLabel!.name = "flightNoteLabel"
            flightNoteCount.position = CGPoint(x: CGRectGetMidX(self.frame), y: flightNoteLabel!.pos.y + 10.00)
            self.addChild(flightNoteCount)
        }
        
        highScoreLabel.text = "High: " + String(self.hsManager.scores.first!.score)
        highScoreLabel.name = "scoreLabels"
        highScoreLabel.fontSize = 20
        highScoreLabel.position = CGPoint(x: (self.frame.width - highScoreLabel.frame.width/2), y: (self.frame.height - highScoreLabel.frame.height))
        
        lastScoreLabel.text = "Previous: " + String(lastScore!)
        lastScoreLabel.name = "scoreLabels"
        lastScoreLabel.fontSize = 20
        lastScoreLabel.position = CGPoint(x: (0.0 + lastScoreLabel.frame.width/2), y: (self.frame.height - highScoreLabel.frame.height))
        
        playButton.text = "Continue"
        playButton.name = "playButton"
        playButton.fontSize = 30
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height/2)
        
        
        self.addChild(highScoreLabel)
        self.addChild(lastScoreLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            let touchedNodeParentName = touchedNode.parent?.name
            
            if touchedNode.name == "playButton" || touchedNodeParentName == "flightNoteLabel" {
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
    
    let notes: [String] = [
        "Welcome to the Ship, I am master Zhang, I am a follower of Master Lao Tzu. As you embark on your journey I will offer you my interpretations of his teachings and how they pertain to being a great pilot. Now tap the note to continue on your journey.",
        "Just as the name of your ship is not the actual ship, so too are these words not the actual way. They are more like an intergalactic road sign, focus too hard on the sign, and you’ll surely miss the turn.",
        "Because there are fast ships, it means there a slow ships. Because there small ships, it means there are big ships. Neither one is wrong, it is just the nature of things.",
        "The master pilot flies without thinking, he does not try too hard, he flies solely on intuition. He leads his crew by example and not by words or force.",
        "Understanding of the ship may seem attainable, but the more the master pilot understands, the more the pilot realizes his lack of understanding. That is why the ship is infinite. The way of the ship existed long before the ship itself.",
        "The ship does not take sides with good or evil, it is just a ship. Therefore the master pilot sees other ships and pilots not as good or evil, but merely the way of the ship in persons, places and things.",
        "The way of the ship is present in all ships. It is not a physical thing, but it is always there, for the pilot, or the ship builder, or the mechanic to use on their journey to understand the ship.",
        "The ship was never born, thus can never die, and certainly does not care about itself. Therefore the master pilot just goes about being a pilot, without trying to achieve. By doing this, the pilot achieves.",
        "The ship travels to undesirable locations as easily as desirable ones. The master pilot flies with grace but still tends to daily ship maintenance with as much as care and attention as when she is flying her ship through a dangerous asteroid belt.",
        "In living, be close to your ship. In dealing with others, see them as future pilots learning the way. In speaking about the ship, stick to what you know to be true. In leading your crew, never try to control. In flying, enjoy every subtle turn or dip.",
        "Because the master pilot and great ship do not seek respect, it is always given. Being content to be the pilot you were born to be, not comparing yourself to other pilots, you will always succeed.",
        "Fill the cargo bay to the brim with treasure from missions and there will be no rom the enjoy the empty space of the ship. When the ship has too many treasures aboard, the ship becomes a target of space pirates.",
        "When the mission is completed, the master pilot goes home to his family and friends, which is the greatest reward.",
        "Can your inner pilot embrace the oneness of your ship with the universe. Forgetting about the desire, glory, the physical state of your ship, can you be the infinitely capable pilot. Can you fly with grace and joy of child flying for the first time.",
        "Can your inner pilot lead the crew with out forcing your intention. Can one pilot lead many with out corruption. Can one land the ship with the gentle touch of a female. Can one forget about flight school and understand the way of the ship and how to fly it.",
        "Showing young pilots the way, achieving without receiving, leading without force, flying without trying, this is the way of the ship.",
        "We make large cargo bays in our steel ships, but its the empty space that leaves room for cargo. Comfy seats are put in cockpit, but the space for the pilot is what makes the ship flyable. The propulsion system surely would not work if there was not empty space for the fuel to burn in.",
        "We use precious metals for our ship, but it is the empty space that makes it useful. Seek the empty space that make ship useful, and not the precious metal that composes it.",
        "Great triumph is as toxic as great failure. It is important, no matter what the circumstances, to remain grounded and humble. Obsession with progress and fear of failure are identical and are a result focusing on the self and not the whole mission.",
        "Love the universe as you do yourself, have trust in the way it is and then you can see all things for what they really are.",
        "Search, it cannot be found. Ear to the engine it, it cannot be heard. Grasp the yoke, it cannot be held. It is unnamable, intangible, shapeless, colorless, the way of the ship is nothing.",
        "We come face to face with the way of the ship and it has no front, we follow it but it has no back. It is nothing, yet when we let the way of the ship take its course, no mission can fail, this is flying.",
        "The pilots of ancient times flew through the universe in unfathomable ways. We can describe it, but it does not do it justice.",
        "Ancient Masters were always hesitant, as if approaching a new planet of an unknown surface. Always cautious, as if entering an asteroid belt. Always humble as guest in a foreign galaxy. Always adaptable to whatever the universe presented, like a crew member looking to help.",
        "Do you have the patience of the ancient pilot? Do you know how to let gravity do the work when navigating the universe. Can you sit still and wait for proper moment to arise before taking action?",
        "The pilots of ancient did not seek change and achievement, they let it come to them. When the oppurtunity for a mission arose, they took it, helping the universe take its course. But they were not mission seekers.",
        "The mind can be emptied of all distractions. Bring the heart to its resting rate. The frustration you see in others is self imposed and temporary. Accomplished or unaccomplished we return to the resting state. Returning to the resting state is peace.",
        "Knowing the resting state we can always return to it. The resting state is the source of all energy. Not knowing the resting state leads to frustration and untimely action. Knowing the resting state, you can see the universe as whole, and be in awe of the way of the ship.",
        "Knowing the resting state, the universe as whole, and the way of the ship, one can proceed without fear and even welcome death.",
        "The captain is at her best when the crew does not know they have a captain. Her next best is when she is loved by her crew. Her next best is feared by her crew. When the captain does not trust her crew, the crew becomes dishonest.",
        "The master pilot captains with action and not words. When the job is done, the crew says, “We did it!”",
        "When the way of the ship is forgotten, morals and righteousness are born. When the crew is tired, they attempt to be clever. When there is no peace in the ship, the captain is honored in a dogmatic manner. When people are confused, they are loyal, but don’t know why. This is a great misfortune.",
        ****
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
        "This is the beauty of teaching without words. The beauty of accomplishment without action. Unattached to the end, the master pilot succeeds.",
        "Fame and wealth, or doing what truly gives you joy? Success or failure, which is more destructive to ones enjoyment of daily progress. Seeking wealth and accolades your craft can never truly be perfected.",
        "Enjoy the process and progress, and not the end goals. Knowing this, heavy gains or heavy losses will not deter you from your daily joy.",
        "Perfection is imperfect, fullness seems to leave a void. What is truly straight, seems bent. Great talent is always raw. Great beauty cannot be described. Movement wards off the cold, stillness makes the heat bearable. Quietness allows the way of the ship to be heard loud and clear.",
        "When the universe is at the peace with the way of ship, cargo ships are built. When the way of the ship is lost, fighter ships are churned out. Fear, greed, and enemies, are all an illusion.",
        "The content pilot has nothing to fear or lose, and can see the enemy as a fellow pilot whose lost their way.",
        "Without ever leaving the parking bay, the master understands ship. Without looking out the window, the master understands the motion of the galaxy.  The more one knows, the less they can observe and understand. The master learns without reading, and accomplishes feats without goals.",
        "In pursuit of an end goal, we add things to the cargo bay until it cannot fit anything more. In the pursuit of the way of the ship, everyday something is removed from the cargo bay until it is empty.  As we empty the bay we learn the only way to learn is to unlearn.",
        "The less things are are forced, the easier they fit into place. The less we force knowledge into our brain, the easier it is the remember, because we learn it is in the way of things, right in front of our eyes, and does not need to be remembered or learned.",
        "The master pilot has no mind of their own. The master pilot takes the mind of the people. The master pilot is good to those who are good, and good to those who are not good. The master pilot is honest with those who are honest, and those who are not honest.",
        "The master pilots mind is a reflection of the universe. The people seek the master pilot with attentive ears and eyes, and the master pilot cares for them like they were their children.",
        "The master pilot has no attachment to youth, life, or death. Their mind is clear of those concepts. Why are they only concepts to the pilot. Because the way of the ship persists, and by embodying it, experiencing it, and teaching it, the master pilot can never die.",
        "Being one with the way of the ship knowing that death and old age are part of a reality we all must face, the master pilot does not worry about death, or getting things done. They go on acting daily, with actions that come naturally from their intuition, never thinking, never doing.",
        "Everything in the universe follows the way of the ship. It was there at the big bang, and it governs the motion of the planets today without conscious effort. It governs physical things but does not call itself a ruler, creates but does not claim ownership.",
        "At the origin of species, there was the way of ship. The first organisms used the way of the ship to spawn and move throughout their universe in their early water dwelling days.",
        "For the first organisms, their observable universe was a warm puddle. They flew around their universe without a cause with the grace and comfort of the best cruiser, at speeds our best racers cannot rival.",
        "If you recognize our origins, you can begin to understand the beauty and perfectness of everything. You will learn to not judge, and can be free of artificial desires. When this is the case, you can let your intuition take over, and follow the way of the ship without trying.",
        "The way of the ship is easy to follow, yet people still find themselves on the side paths. When the rich over indulge, while the poor struggle to find food and water; When the government builds opts to build weapons over hospitals in times of peace, this is not the way of the ship.",
        "What is firmly planted with the way of ship cannot be uprooted. What is held closely in keeping with the way of the ship does not slip away. Work done in accordance with the way of the ship always endures many generations.",
        "When the way of the ship is present in your day to day, your actions will be true. When the way of ship is present in your family, the family will grow in size and love for one another. When it is present in the country, others follow suit.",
        "How do we know letting the way of the ship be present has these amazing results? Because we let it everyday when a new baby is born, when child learns to fly, or when the earth makes a trip around the sun, or when the stars come out at night.",
        "With an abundance of virtue, one becomes like a newborn baby. Poisonous insects do not sting them, wild beast do not scratch them, birds of prey do not attack them. Bones and muscles are weak, but their grip is strong.",
        "Newborns can cry the whole without losing there voice. This is because newborns know the harmony of there body without knowing. Knowing harmony is stability. Stability brings clarity of mind.",
        "The over active suffer injury. The over thinkers find themselves not knowing what to do. When things become too strong they lose their flexibility. Be like the newborn, soft and unthinking, acting only when the body tells it to. This is the way of the ship.",
        "Those who know, do not talk, those who talk, do not know. Close your mouth, disregard your judgements, forget about your rules for living, withhold your reaction, do not stare is dissapproval. This is how to be one with the way.",
        "Being like the ship and its way, you cannot be approved of or disapproved of. You cannot be awarded or punished. You just are, your way is to fly, you lend your self to whoever steps on board, this is how the ship and its way endure.",
        "In order for the universe to governed well its government must learn to step back and let the ship take its course. The universe has been governing itself long before man existed, why should man try to govern man and the universe when the universe will do it for them.",
        "When you create rules your create rule breakers. When you create weapons you create murders. The more government assistance there is, the less men learn to fend for themselves.",
        "The master pilot gives up law, and people act with integrity. The master gives up trying to fix the economy, and the people find ways to prosper with the solutions that existed in the natural economy, and are therefore more sustainable. The master gives up trying to make the people moral and religious, and they naturally tend toward peace and quiet.",
        "When the master stops forcing things, everything falls into place.",
        "When the universe is governed with telescope from afar, the people are good. When the universe is governed with a microscope over every action, the people are opressed, and look for loopholes to exploit or secret passageways to escape from sight.",
        "Misfortune and fortune are opposite forces. Trying to create fortune only ends in misfortune. Forcing good turns into violence, forcing rightness turns into dogma.",
        "The master pilot is incorruptible without being disagreeable. The master pilot gets to the point without seeming urgent. The master pilot is like guiding light, but is not blinding.",
        "Everything in moderation is what the master pilots grandmother always said. And this is true for governing. The moderate governor knows when to stop. Knowing when to stop all branches, the governor and the pilot do not over extend themselves.",
        "Not over extending themselves, they can make use of whatever situation arises. Being able to make use of whatever situation, there is nothing they cannot overcome. With nothing one cannot overcome, ones limits and potential become unknown.",
        "With ones potential unknown, power is naturally entrusted in the master pilot. Because it is naturally entrusted, and not gained through desire, the master is free to care for and teach the people the way a mother teaches and cares for her child.",
        "Ruling a universe is like flying a small ship. The ride is bumpy when the pilot over compensates for space debris.",
        "Center the universe in the way of the ship and wicked ways will have no place. They will be present, but they will get no reaction from the people. With no one to upset, the profoundly wicked have no drive to perform wrong deeds, and will fade into the background.",
        "A great country is like a massive star system. The massive stars gravity is symbolic of good politics. The better the politics, the more massive the star becomes. The more massive the star is, the more planets naturally fall into its gravitational pull. The star nourishes orbiting planets.",
        "The way of the ship is at the center of all things. A good pilots principles, a evil mans shelter from himself. Medals can be won for brave actions, certificates can be awarded for good politics, but the way of ship cannot be achieved, or handed out like a prize.",
        "When a new pilot is chosen to lead a fleet or a country, do not offer medals or flying lessons. Offer to teach him about the ways of the ship.",
        "Why did ancient pilots believe in the way of the ship? Because by being one with the ship, when you go to fix whats broken, you succeed, when you fail, you try again and succeed, gaining a deeper understanding of the ships unspeakable beauty.",
        "Flying without trying. Acting without doing. Teaching without speaking. Facing the difficult while it is still easy. Viewing the easy as difficult. Completing the great mission by seeing it as a sequence of small missions. This is the master pilots way, and the way to building a great ship.",
        "The master pilot does try to be great, and therefore is great. Be weary of the pilot who promises great success. The pilot who sees all things as easy encounters many difficulties. The pilot who sees all things as difficult, never encounters difficulty.",
        "A single loose screw is easy to tighten. A single mistake is easy to correct. Cleaning up is easiest before the mess gets out of hand. A small problem is easiest to fix before it arises.",
        "The greatest mother ship was built from nothing but a single plan. The plan for the great mother ship started with a single line. The mission of thousand light years starts with a single take off.",
        "Trying to accomplish great things in a single act you will fail. Try to force completion of something that was almost done, you will fail. View the remaining tasks as you did the first task, as a single step, and do not worry about being on the last step.",
        "Therefore, the master pilot desires non-desire. Not desiring the end, they can give themselves fully to the task at hand. They do not have anything, so they have nothing to lose. What they learn is to not learn. Reminding people the way is present in them this very moment.",
        "The way of the ship is their highest value.",
        "The master pilots did not try to teach the way of the ship. They simply taught that you can not know all there is to know about the way of the ship. When people think they know how to fix the ship, they are hard to show to the way of the ship and how to fix it",
        "When people know that they don’t all there is to know about the ship and how to fix it, they are free to discover what is truly broken, and what the best solution to fixing it is.",
        "If you want to be a good captain to your crew, stop trying to be brighter then your crew. Being the dumbest crew member, your crew will learn how to operate without you, and all crew members will know how to rise to the challenge of a dangerous mission or a profoundly damaged ship.",
        "Black holes smaller then a pin prick are the center piece for many stars and planets. They are small but have great mass. the master is small like a blackhole, do not be fooled by his small appearance, the master’s wisdom is massive and dense.",
        "The master, being small, treats the crew as smarter then himself. Treating the crew this way, he learns from their mistakes. Being the leader of the crew, the master lets the crew decide what is best.",
        "The master, constantly putting the crew first, the crew naturally desires to elevate the captain, rather than the master forcing their elevated position upon the crew. The master does not seek to be better then anyone, therefore, no ones tries to prove themselves better than the master.",
        "The words that describe the way of the ship can certainly sound silly and prophetic to someone who has never flown. But the those who have experienced that first flight, gracefully soaring on natures nature know these words describe something far beyond words capacity.",
        "The master pilot holds three golden treasures, compassion, non-desire for material goods, and non-desire for power. Through compassion the master for herself and the people, the master understands desire for material goods and power.",
        "Through non-desire for material goods and power, the master achieves an understanding of nature unfathomable. Through this values the master can fly with grace that can only be experienced, not imagined.",
        "The best fighter pilot, having compassion for the enemy, wants the enemy at their best, for the spirit of competition, not at their weakest for the pettiness of victory. The best pilots do not use anger towards the enemy as a source of strength. The great pilot waits for enemy to advance.",
        "Great competition is what makes the master pilot better, but he is not competitive. Competition is just a catalyst for deeper understanding to his craft. Compassionate for the enemy he can enjoy, and grow from the enemies progress.",
        "The master pilots say it is better to let the enemy make the first move. Better to retreat a meter then advance 100. This is how to gain space without flying far, pushing the enemy back without firing a single laser.",
        "There is no bigger mistake then underestimating the enemy.  Underestimating the enemy is forget they are fellow pilots with families at home as well. Underestimating the enemy, through lack of compassion, you forget you three treasures, and become the evil enemy yourself.",
        "When two evenly matched pilots face each other, the more compassionate one always wins, by being able to enter the mind of the enemy.",
        "My words are easy to understand and easy to practice, but by trying to practice them or understand them, that is when you will fail. These words come from the principles that governed the big bang and the origin of species.",
        "These words go deeper then a mans existence and can never be fully understood. But, because what they represent was there at human kinds beginning, we can begin to understand them. We do this by not trying to understand them, being honest with ourselves, taking in our surroundings, and being ourself.",
        "To know and think you do not know is true health. To not know and think you know is a sickness. The thought of having this sickness is enough to avoid being infected by it. The master knows how excruciatingly painful this sickness would be and therefore does not have it.",
        "When people lose their respect for natures forces, dogmatic forces take root. The master teaches by not teaching, and lets the people find there way, this is their true nature.",
        "The way of the ship does not compete but is always winning. It does not speak but always gives the perfect response. It is not called for yet it is always there. Is not rushed but can plan ahead. Its mesh of its net is wide but nothing passed through.",
        "Realizing the universe is in constant motion, and that change is in its nature, you can let go of anxiety about change. Realizing death is something all organisms experience before returning to mother earth, you realize that there is nothing to fear.",
        "Trying to control change and skirt death is like trying to use the master welders tools. You will get burnt. Embracing change and death, you can work with it, and become welders apprentice, and in time, there will be no ship you cannot build.",
        "When taxes are too high, the people starve. When the government imposes to much of its will upon the people, the people become difficult to govern. Leave the people alone and they will feed themselves and act in good nature.",
        "During life a human is soft and bending. After death, stiff and brittle. This holds true for the branch of a tree as well, alive it is bending and cannot be broken, dead, brittle and easy to break.  Soft and bending is a sign of life, and will alway be above the stiff and unbending.",
        "The way of the ship is like the bending of bow. The top part is brought down, and the bottom part brought up, and strength is distributed evenly through out the bow. The way of the ship reduces surpluses and adds to what is lacking.",
        "Trying to control things and using force to protect ones position in life goes against the way of the ship. Taking from those who do not have enough and giving to those who have to too much is the way of man who has lost his way.",
        "The master pilot can give continually because their wealth is infinite. The master pilot acts without expecting anything, accomplishes without getting recognition, and never need to display their wisdom, accomplishments or abilities.",
        "Water is weak, soft and bending. But when it comes to break down the stiff and hard, there is nothing better. Weak weakens the strong, soft softens the hard, we all know it, but have trouble putting it into practice.",
        "Knowing water, the master pilot says bearing the humiliation of a planet, you are fit to lead it. Taking on the pitfalls of the planet, you become its King. The closer we get to the truth, the more paradoxical it becomes.",
        "Blame only creates more blame. When dealing with anything that involves others, the master pilot only worries about holding up her side of the deal and never demands it of others, or blames others for shortcomings. The way of the ship takes no sides, it sees things only for what they are.",
        "When the planet is governed with the way of the ship, the people are content and the planet preserved. The people enjoy there work, and do not seek to consume more then they need to survive.",
        "The people of a planet well governed have modest, comfortable homes which they love. They have ships that can take them to far away places, but do not need them because they are contented in there work and homes. There weapons on this planet, but there is no need for them.",
        "The people of the well governed planet take immense joy in meals with family and friends. They enjoy tuning up there ship on weekends. There are destinations nearby, but there is no need to go visit them. The small beauty of their neighborhood within the grand universe is what makes them content to grow old and die there.",
        "True words are not beautiful. Beautiful words are not true. Old masters never need to explain their point. Men who always need to explain their point, don’t have one.",
        "The old master owns nothing. The more she helps others, the more fortunate she becomes. The more she gives to others, the more prosperous she becomes.",
        "The way of the ship gives to all things without meddling. By not doing, the master teaches, through non action, the people learn."
        ]
}
