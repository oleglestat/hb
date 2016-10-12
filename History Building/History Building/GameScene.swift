//
//  GameScene.swift
//  History Building
//
//  Created by Oleg Chmut on 10/10/16.
//  Copyright © 2016 RoyalInn. All rights reserved.
//
//  https://trello.com/b/9JnNlbfz/history-building - agile board

import SpriteKit

	// MARK: - Game States
enum GameStatus: Int {
	case waitingForTap = 0
	case playing = 1
}

enum PlayerStatus: Int {
	case idle = 0
	case fly = 1
}

struct PhysicsCategory {
	static let None: UInt32 = 0
	static let Player: UInt32 = 0b1 // 1
	static let Platform: UInt32 = 0b10 // 2
	static let Edges: UInt32 = 0b100000 // 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	// MARK: - Properties
	
	// weak reference to viewController of game scene
	weak var viewController: GameViewController!
	
	// world
	var bgNode: SKNode!
	var fgNode: SKNode!
	var platformsNode: SKNode!
	
	// player
	var player: SKSpriteNode!
	var playerVector = CGVector(dx: 0.0, dy: 0.0)
	//let playerAnimation: SKAction
	
	// game status
	var gameState = GameStatus.waitingForTap
	var playerState = PlayerStatus.idle
	
	// camera
	let cameraNode = SKCameraNode()
	
	// called when scene loaded
	override func didMove(to view: SKView) {
		physicsWorld.contactDelegate = self
		setupNodes()
		// scaling up Ready image
		let scale = SKAction.scale(to: 1.0, duration: 0.5)
		fgNode.childNode(withName: "ready")!.run(scale)
	}
	
	// function used to update frame display
	override func update(_ currentTime: TimeInterval) {
		print(playerVector)
		updatePlayer()
		updateCamera()
	}
	
	func setupNodes() {
		// assigning scene objects to variables
		let worldNode = childNode(withName: "World")!
		bgNode = worldNode.childNode(withName: "Background")!
		fgNode = worldNode.childNode(withName: "Foreground")!
		platformsNode = worldNode.childNode(withName: "PlatformsOverlay")!
		player = fgNode.childNode(withName: "player") as! SKSpriteNode
		// adding scale to cameraNode, adding camera to scene and setting camera property
		cameraNode.xScale = 0.5
		cameraNode.yScale = 0.5
		addChild(cameraNode)
		camera = cameraNode
	}
	
	// MARK: - Events
	
	// called when player touches screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if gameState == .waitingForTap {
			gameState = .playing
			removeReady()
			player.physicsBody!.isDynamic = true
		}
	}
	
	func removeReady() {
		fgNode.childNode(withName: "ready")!.removeFromParent()
		fgNode.childNode(withName: "textLabel")!.removeFromParent()
	}
	
	func updatePlayer() {
		// applying constant force to player
		player.physicsBody!.applyForce(playerVector)
	}
	
	func updateCamera() {
		// setting camera right on player
		let cameraTarget = convert(player.position, from: fgNode)
		cameraNode.position = cameraTarget
	}
	
//	var textures:[SKTexture] = []
//	for i in 1...4 {
//	textures.append(SKTexture(imageNamed: "h\(i)"))
//	}
//	playerAnimation = SKAction.animate(with: textures,
//	timePerFrame: 0.1)


}
