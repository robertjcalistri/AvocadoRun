import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Define background layers and their speeds
    
    // Set up the player
        let player = SKSpriteNode(imageNamed: "avocado")

        // Set up the platforms
        let platform1 = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100, height: 20))
        let platform2 = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100, height: 20))
        
        override func didMove(to view: SKView) {
            backgroundColor = SKColor.white
            
            // Position the player on the screen
            player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
            addChild(player)
            
            // Position the platforms
            platform1.position = CGPoint(x: size.width, y: size.height * 0.3)
            addChild(platform1)
            
            platform2.position = CGPoint(x: size.width + platform1.size.width * 1.5, y: size.height * 0.3)
            addChild(platform2)
        }
    
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            
            // Move the platforms
            platform1.position = CGPoint(x: platform1.position.x - 2, y: platform1.position.y)
            platform2.position = CGPoint(x: platform2.position.x - 2, y: platform2.position.y)
            
            // Check if we need to move the first platform to the right
            if platform1.position.x + platform1.size.width < 0 {
                platform1.position = CGPoint(x: platform2.position.x + platform2.size.width + platform1.size.width, y: platform1.position.y)
            }
            
            // Check if we need to move the second platform to the right
            if platform2.position.x + platform2.size.width < 0 {
                platform2.position = CGPoint(x: platform1.position.x + platform1.size.width + platform2.size.width, y: platform2.position.y)
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // The player jumps when the screen is touched
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
}


