import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))

    // Set up the ground variables
    var groundTiles = [SKSpriteNode]()
    var lastGroundTileX: CGFloat = 0.0
    var lastGroundTileY: CGFloat = 0.0
    let groundTileWidth: CGFloat = 100.0 // Adjust this based on your desired ground tile width
    let maxPlatformHeight: CGFloat = 100.0 // Maximum height difference between platforms
    
    var gameOverLabel: SKLabelNode!
    var isGameOver = false

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.zPosition = 1

        // Set the player's position
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)

        addChild(player)

        // Generate initial ground tiles
        generateGround()
        
        // Generating game over
        gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.text = "Game Over! Tap to restart"
        gameOverLabel.fontSize = 65
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.zPosition = 2
    }

    override func update(_ currentTime: TimeInterval) {
        if player.position.y < -size.height / 2 {
            if !isGameOver {
                gameOver()
            }
        } else {
            moveGround()
        }
    }

    
    func gameOver() {
        isGameOver = true
        player.physicsBody?.isDynamic = false
        addChild(gameOverLabel)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restartGame()
        } else {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
    }

    func restartGame() {
        gameOverLabel.removeFromParent()
        isGameOver = false
        player.physicsBody?.isDynamic = true
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        lastGroundTileX = 0.0
        lastGroundTileY = 0.0
        groundTiles.forEach { $0.removeFromParent() }
        groundTiles.removeAll()
        generateGround()
    }

    func generateGround() {
        // Generate ground tiles and add them
        while lastGroundTileX < size.width {
            let groundTile = SKSpriteNode(color: SKColor.black, size: CGSize(width: groundTileWidth, height: 20))
            let randomHeight = CGFloat.random(in: -maxPlatformHeight...maxPlatformHeight)
            groundTile.position = CGPoint(x: lastGroundTileX, y: lastGroundTileY + randomHeight)
            groundTile.physicsBody = SKPhysicsBody(rectangleOf: groundTile.size)
            groundTile.physicsBody?.isDynamic = false
            addChild(groundTile)
            groundTiles.append(groundTile)

            lastGroundTileX += groundTileWidth
            lastGroundTileY = groundTile.position.y
        }
    }

    func moveGround() {
        // Move the ground tiles to the left
        for (index, groundTile) in groundTiles.enumerated() {
            groundTile.position = CGPoint(x: groundTile.position.x - 2, y: groundTile.position.y)

            // Check if the left edge of the ground tile is completely off the left edge of the screen
            if groundTile.position.x - groundTileWidth / 6 < -size.width / 2{
                groundTile.removeFromParent()
                groundTiles.remove(at: index)

                // Add a new ground tile to the right
                let newGroundTile = SKSpriteNode(color: SKColor.black, size: CGSize(width: groundTileWidth, height: 20))
                let randomHeight = CGFloat.random(in: -maxPlatformHeight...maxPlatformHeight)
                newGroundTile.position = CGPoint(x: lastGroundTileX, y: lastGroundTileY + randomHeight)
                newGroundTile.physicsBody = SKPhysicsBody(rectangleOf: newGroundTile.size)
                newGroundTile.physicsBody?.isDynamic = false
                addChild(newGroundTile)
                groundTiles.append(newGroundTile)

                lastGroundTileX += groundTileWidth
                lastGroundTileY = newGroundTile.position.y
            }
        }
    }
}
