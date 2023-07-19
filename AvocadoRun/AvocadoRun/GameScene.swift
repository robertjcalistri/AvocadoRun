import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))

    let floor = SKSpriteNode()

    // Set up the ground variables
    var groundTiles = [SKSpriteNode]()
    var lastGroundTileX: CGFloat = 0.0
    let groundTileWidth: CGFloat = 100.0 // Adjust this based on your desired ground tile width

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.zPosition = 1

        // Set the player's position
        player.position = CGPoint(x: size.width * 0.01, y: size.height * 0.01)

        addChild(player)

        floor.size = CGSize(width: size.width, height: 100) // Set size of floor
        floor.position = CGPoint(x: size.width / 8, y: floor.size.height / 8) // Set position of floor
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        addChild(floor)

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
            groundTile.position = CGPoint(x: lastGroundTileX, y: floor.size.height / 2 + groundTile.size.height / 2)
            groundTile.physicsBody = SKPhysicsBody(rectangleOf: groundTile.size)
            groundTile.physicsBody?.isDynamic = false
            addChild(groundTile) // Add groundTile to scene directly, not to floor
            groundTiles.append(groundTile)

            lastGroundTileX += groundTileWidth
        }
    }

    func moveGround() {
        // Move the ground tiles to the left
        for groundTile in groundTiles {
            groundTile.position = CGPoint(x: groundTile.position.x - 2, y: groundTile.position.y)

            // If the ground tile moves off the left edge, move it to the right
            if groundTile.position.x + groundTileWidth < 0 {
                groundTile.position = CGPoint(x: lastGroundTileX, y: groundTile.position.y)
                lastGroundTileX += groundTileWidth
            }
        }
    }
}
