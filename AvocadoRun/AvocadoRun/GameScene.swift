import SpriteKit
import GameplayKit
import Firebase
import FirebaseDatabase

class GameScene: SKScene {
    let player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    
    var lastJumpTime: TimeInterval = 0
    let jumpCooldown: TimeInterval = 0.6
    
    var leaderboardLabel: SKLabelNode!
    
    // Set up the ground variables
    var groundTiles = [SKSpriteNode]()
    var lastGroundTileX: CGFloat = 0.0
    var lastGroundTileY: CGFloat = 0.0
    let groundTileWidth: CGFloat = 100.0 // Adjust this based on your desired ground tile width
    let maxPlatformHeight: CGFloat = 100.0 // Maximum height difference between platforms
    
    var gameOverLabel: SKLabelNode!
    var isGameOver = false
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    
    var highScoreLabel: SKLabelNode!
    var highestScore: Int = 0
    
    var currentUser: User?
    
    override func didMove(to view: SKView) {
        
        let backgroundImg = SKSpriteNode(imageNamed: "Menubackground")
        backgroundImg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImg.zPosition = -1
        addChild(backgroundImg)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.zPosition = 1
        
        // Player physics
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        
        // Set the player's position
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)

        addChild(player)

        // Generate initial ground tiles
        generateGround()
        
        // Generating game over
        gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.text = "Game Over! Tap to restart"
        gameOverLabel.fontSize = 30
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.zPosition = 2
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - scoreLabel.frame.size.height * 4)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        startScoring()
        print("Score Label: \(scoreLabel)")
        print("Game Over Label: \(gameOverLabel)")
        
        leaderboardLabel = SKLabelNode(fontNamed: "Arial")
        leaderboardLabel.fontSize = 20
        leaderboardLabel.fontColor = SKColor.black
        leaderboardLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        leaderboardLabel.zPosition = 2
        addChild(leaderboardLabel)
        
        
        highScoreLabel = SKLabelNode(fontNamed: "Arial")
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height - highScoreLabel.frame.size.height - 10)
        highScoreLabel.zPosition = 2
        addChild(highScoreLabel)
        
        loadHighScore()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            self.currentUser = user
        }
        
        observeLeaderboard()
        leaderboardLabel.isHidden = true

    }
    
    func startScoring() {
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
            print("Score: \(self.score)")
        })
        let sequence = SKAction.sequence([wait,block])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    override func update(_ currentTime: TimeInterval) {
        if player.position.y < 0 || player.position.y > size.height {
            if !isGameOver {
                gameOver()
            }
        } else {
            moveGround()
        }
    }

    
    func gameOver() {
        print("Game Over function called")
        isGameOver = true
        player.physicsBody?.isDynamic = false
        addChild(gameOverLabel)
        removeAllActions()
        saveHighScore()
        leaderboardLabel.isHidden = false
        loadLeaderboard()
    }
    
    func loadHighScore() {
        if let currentUser = Auth.auth().currentUser {
            // Use the user's UID as the key for the high score in Firebase
            let highScoreRef = Database.database().reference().child("highScores").child(currentUser.uid)

            highScoreRef.observe(.value) { snapshot in
                if let highScore = snapshot.value as? Int {
                    // Update the highest score if the retrieved high score is greater
                    self.highestScore = max(highScore, self.highestScore)
                }
                self.highScoreLabel.text = "High Score: \(self.highestScore)"
            }
        } else {
            // User is not logged in, so there's no high score to load
            self.highScoreLabel.text = "High Score: 0"
        }
    }
    
    func saveHighScore() {
        if let currentUser = self.currentUser {
            // Use the user's UID as the key for the high score in Firebase
            let highScoreRef = Database.database().reference().child("highScores").child(currentUser.uid)

            // Update the high score in Firebase if the current score is greater
            highScoreRef.setValue(max(score, highestScore))

            // Also save the player's email along with the high score
            if let email = currentUser.email {
                let leaderboardEntry = LeaderboardEntry(email: email, highScore: max(score, highestScore))
                let leaderboardRef = Database.database().reference().child("leaderboard").child(currentUser.uid)
                leaderboardRef.setValue(leaderboardEntry.toDictionary())
            }
        }
    }
    
    func loadLeaderboard() {
        let leaderboardRef = Database.database().reference().child("leaderboard")

        // Observe the leaderboard data and update the leaderboardLabel accordingly
        leaderboardRef.observe(.value) { snapshot in
            var leaderboardData = [LeaderboardEntry]()

            // Loop through the snapshot to retrieve the leaderboard entries
            for childSnapshot in snapshot.children {
                if let childDataSnapshot = childSnapshot as? DataSnapshot,
                   let data = childDataSnapshot.value as? [String: Any],
                   let email = data["email"] as? String,
                   let highScore = data["highScore"] as? Int {
                    let leaderboardEntry = LeaderboardEntry(email: email, highScore: highScore)
                    leaderboardData.append(leaderboardEntry)
                }
            }

            // Sort the leaderboardData by high score (highest to lowest)
            leaderboardData.sort(by: { $0.highScore > $1.highScore })

            // Update the leaderboardLabel to show the leaderboard
            var leaderboardText = "Leaderboard:\n"
            for (index, entry) in leaderboardData.prefix(10).enumerated() {
                let playerName = entry.email.components(separatedBy: "@").first ?? "Unknown"
                leaderboardText += "\(index + 1). \(playerName): \(entry.highScore)\n"
            }
            
            // Set the leaderboardLabel's text and numberOfLines property
            self.leaderboardLabel.text = leaderboardText
            self.leaderboardLabel.numberOfLines = 0
        }
    }

    
    func observeLeaderboard() {
        let leaderboardRef = Database.database().reference().child("leaderboard")

        // Observe the leaderboard data and update the highScoreLabel accordingly
        leaderboardRef.observe(.value) { snapshot in
            var leaderboardData = [LeaderboardEntry]()

            // Loop through the snapshot to retrieve the leaderboard entries
            for childSnapshot in snapshot.children {
                if let childDataSnapshot = childSnapshot as? DataSnapshot,
                   let data = childDataSnapshot.value as? [String: Any],
                   let email = data["email"] as? String,
                   let highScore = data["highScore"] as? Int {
                    let leaderboardEntry = LeaderboardEntry(email: email, highScore: highScore)
                    leaderboardData.append(leaderboardEntry)
                }
            }

            // Sort the leaderboardData by high score (highest to lowest)
            leaderboardData.sort(by: { $0.highScore > $1.highScore })

            // Update the leaderboardLabel to show the leaderboard
            var leaderboardText = "Leaderboard:\n"
            for (index, entry) in leaderboardData.prefix(10).enumerated() {
                let playerName = entry.email.components(separatedBy: "@").first ?? "Unknown"
                leaderboardText += "\(index + 1). \(playerName): \(entry.highScore)\n"
            }
            self.leaderboardLabel.text = leaderboardText
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isGameOver {
                restartGame()
            } else {
                let currentTime = touches.first?.timestamp ?? 0
                if currentTime - lastJumpTime >= jumpCooldown {
                    if let dy = player.physicsBody?.velocity.dy {
                        if dy < 0 {
                            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 130))
                        }
                        else{
                            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                        }
                        lastJumpTime = currentTime
                    }
                }
                
            }
        }
    
    func restartGame() {
        leaderboardLabel.isHidden = true
        gameOverLabel.removeFromParent()
        isGameOver = false
        player.physicsBody?.isDynamic = true
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        lastGroundTileX = 0.0
        lastGroundTileY = 0.0
        groundTiles.forEach { $0.removeFromParent() }
        groundTiles.removeAll()
        generateGround()
        startScoring()
        
        currentUser = Auth.auth().currentUser
        observeLeaderboard()
        
        // Reset score
        score = 0
        scoreLabel.text = "Score: \(score)"
    }
    
    func generateGround() {
        // Generate ground tiles and add them
        while lastGroundTileX < size.width {
            let groundTile = SKSpriteNode(color: SKColor.brown, size: CGSize(width: groundTileWidth, height: 20))
            let randomHeight = CGFloat.random(in: 0...maxPlatformHeight) // Platforms can only go upwards
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
            if groundTile.position.x - groundTileWidth / 2 < -size.width / 2 {
                groundTile.removeFromParent()
                groundTiles.remove(at: index)

                // Add a new ground tile to the right
                let newGroundTile = SKSpriteNode(color: SKColor.brown, size: CGSize(width: groundTileWidth, height: 20))
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
class LeaderboardEntry {
    var email: String
    var highScore: Int
    
    init(email: String, highScore: Int) {
        self.email = email
        self.highScore = highScore
    }

    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "highScore": highScore
        ]
    }
}
