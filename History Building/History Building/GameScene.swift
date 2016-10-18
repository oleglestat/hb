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
		setCameraConstraints()
		physicsWorld.contactDelegate = self
		setupNodes()
		setCameraConstraints()
		// scaling up Ready image
		let scale = SKAction.scale(to: 1.0, duration: 0.5)
		fgNode.childNode(withName: "ready")!.run(scale)
	}
	
	// function used to update frame display
	override func update(_ currentTime: TimeInterval) {
		updatePlayer()
		boundsCheck()
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
	
	func boundsCheck() {
		var playerPos = convert(player.position, from: fgNode)
		let bottomLeft = CGPoint.zero + CGPoint(x: player.size.width/2, y: player.size.height/2)
		let topRight = CGPoint(x: size.width - player.size.width/2, y: size.height - player.size.height/2)
		
		print("converted player \(playerPos)")
		//print("regular player \(player.position)")
		print("BL \(bottomLeft)")
		print("TR \(topRight)")
		
		if playerPos.x <= bottomLeft.x {
			playerPos = convert(CGPoint(x: bottomLeft.x, y: playerPos.y), to: fgNode)
			player.position = playerPos
			player.physicsBody!.velocity.dx = 0
		}
		if playerPos.x >= topRight.x {
			playerPos = convert(CGPoint(x: topRight.x, y: playerPos.y), to: fgNode)
			player.position = playerPos
			player.physicsBody!.velocity.dx = 0
		}
		if playerPos.y <= bottomLeft.y {
			playerPos = convert(CGPoint(x: playerPos.x, y: bottomLeft.y), to: fgNode)
			player.position = playerPos
			player.physicsBody!.velocity.dy = 0
		}
		if playerPos.y >= topRight.y {
			playerPos = convert(CGPoint(x: playerPos.x, y: topRight.y), to: fgNode)
			player.position = playerPos
			player.physicsBody!.velocity.dy = 0
		}
	}
	
	//Camera setting: following player and respecting background edges
	private func setCameraConstraints() {
		// Don't try to set up camera constraints if we don't yet have a camera.
		guard let camera = camera else { return }
		
		// Constrain the camera to stay a constant distance of 0 points from the player node.
		let zeroRange = SKRange(constantValue: 0.0)
		let playerLocationConstraint = SKConstraint.distance(zeroRange, to: player)
		
		/*
		Also constrain the camera to avoid it moving to the very edges of the scene.
		First, work out the scaled size of the scene. Its scaled height will always be
		the original height of the scene, but its scaled width will vary based on
		the window's current aspect ratio.
		*/
		let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
		
		/*
		Find the root "board" node in the scene (the container node for
		the level's background tiles).
		*/
		//let boardNode = childNodeWithName(WorldLayer.Board.nodePath)!
		
		/*
		Calculate the accumulated frame of this node.
		The accumulated frame of a node is the outer bounds of all of the node's
		child nodes, i.e. the total size of the entire contents of the node.
		This gives us the bounding rectangle for the level's environment.
		*/
		let boardContentRect = bgNode.calculateAccumulatedFrame()
		
		/*
		Work out how far within this rectangle to constrain the camera.
		We want to stop the camera when we get within 100pts of the edge of the screen,
		unless the level is so small that this inset would be outside of the level.
		*/
		let xInset = min((scaledSize.width / 2), boardContentRect.width / 2)
		let yInset = min((scaledSize.height / 2), boardContentRect.height / 2)
		
		// Use these insets to create a smaller inset rectangle within which the camera must stay.
		let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
		
		// Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
		let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
		let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
		
		// Constrain the camera within the inset rectangle.
		let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
		levelEdgeConstraint.referenceNode = bgNode
		
		/*
		Add both constraints to the camera. The scene edge constraint is added
		second, so that it takes precedence over following the `PlayerBot`.
		The result is that the camera will follow the player, unless this would mean
		moving too close to the edge of the level.
		*/
		camera.constraints = [playerLocationConstraint, levelEdgeConstraint]
	}
	
	
//	var textures:[SKTexture] = []
//	for i in 1...4 {
//	textures.append(SKTexture(imageNamed: "h\(i)"))
//	}
//	playerAnimation = SKAction.animate(with: textures,
//	timePerFrame: 0.1)


}
