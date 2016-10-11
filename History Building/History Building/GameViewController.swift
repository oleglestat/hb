//
//  GameViewController.swift
//  History Building
//
//  Created by Oleg Chmut on 10/10/16.
//  Copyright © 2016 RoyalInn. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	@IBOutlet weak var torqueControll: UISlider! {
		didSet{
			torqueControll.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
		}
	}
	@IBOutlet weak var tiltControll: UISlider!
	
	var currentGame: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
		
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
				currentGame = scene as! GameScene
				currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
	
	@IBAction func torqueChanged(_ sender: UISlider) {
		//currentGame.player.physicsBody!.velocity.dy = CGFloat(torqueControll.value)
		//currentGame.player.physicsBody!.applyForce(CGVector(dx: 0.0, dy: CGFloat(torqueControll.value) * 100))
		currentGame.playerVector.dy = CGFloat(torqueControll.value) * 10
	}
	
	@IBAction func tiltChanged(_ sender: UISlider) {
		//currentGame.player.physicsBody!.velocity.dx = CGFloat(tiltControll.value)
		currentGame.playerVector.dx = CGFloat(tiltControll.value)

	}
	
}
