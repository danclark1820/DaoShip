//
//  GameViewController.swift
//  DaoShip
//
//  Created by Daniel Clark on 2/6/16.
//  Copyright (c) 2016 Daniel Clark. All rights reserved.
//

import UIKit
import GameKit
import SpriteKit

class GameViewController: UIViewController,  GKGameCenterControllerDelegate {
    
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        
        if let scene =  MainScene(fileNamed: "MainScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.showsPhysics = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = self.view.frame.size
            skView.presentScene(scene)
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLeaderBoard() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func submitHighscore(score:Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "ShipDipLeaderboard") //leaderboard id here
            scoreReporter.value = Int64(score) //score variable here (same as above)
            let scoreArray: [GKScore] = [scoreReporter]

            GKScore.reportScores(scoreArray, withCompletionHandler: {(error: NSError?) in
                if error != nil {
                    print("error")
                }
            })
        }
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
