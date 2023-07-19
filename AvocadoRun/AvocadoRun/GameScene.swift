import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))

    // Set up the ground variables
    var groundTiles = [SKSpriteNode]()
    var lastGroundTileX: CGFloat = 0.0
    let groundTileWidth: CGFloat = 100.0 // Adjust this based on your desired ground tile width

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.zPosition = 1

        // Set the player's position
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)

        addChild(player)

        // Generate initial ground tiles
        generateGround()
    }

    override func update(_ currentTime: TimeInterval) {
        // Move the ground
        moveGround()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // The player jumps when the screen is touched
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
    }

    func generateGround() {
        // Generate ground tiles and add them
        while lastGroundTileX < size.width {
            let groundTile = SKSpriteNode(color: SKColor.black, size: CGSize(width: groundTileWidth, height: 20))
            groundTile.position = CGPoint(x: lastGroundTileX, y: groundTile.size.height / 2)
            groundTile.physicsBody = SKPhysicsBody(rectangleOf: groundTile.size)
            groundTile.physicsBody?.isDynamic = false
            addChild(groundTile)
            groundTiles.append(groundTile)

            lastGroundTileX += groundTileWidth
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
                newGroundTile.position = CGPoint(x: lastGroundTileX, y: newGroundTile.size.height / 2)
                newGroundTile.physicsBody = SKPhysicsBody(rectangleOf: newGroundTile.size)
                newGroundTile.physicsBody?.isDynamic = false
                addChild(newGroundTile)
                groundTiles.append(newGroundTile)

                lastGroundTileX += groundTileWidth
            }
        }
    }
}
