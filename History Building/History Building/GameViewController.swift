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
	
	// Outlet for sliders
	@IBOutlet weak var torqueControll: UISlider! {
		didSet{
			// rotating left slider to 90 degrees
			torqueControll.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
		}
	}
	@IBOutlet weak var tiltControll: UISlider!
	
	// strong reference to game scene (*.sks) inside viewController
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
				// setting property for direct access to scene
				currentGame = scene as! GameScene
				// giving access to viewController to scene
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
		currentGame.playerVector.dy = CGFloat(torqueControll.value) * 10
	}
	
	@IBAction func tiltChanged(_ sender: UISlider) {
		currentGame.playerVector.dx = CGFloat(tiltControll.value)

	}
	
}
