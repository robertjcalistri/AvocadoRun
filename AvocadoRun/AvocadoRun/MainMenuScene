import SpriteKit

class MainMenuScene: SKScene {
    let playButton = SKLabelNode(text: "Play")
    
    override func didMove(to view: SKView) {
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                if let view = self.view {
                    let gameScene = GameScene(size: view.bounds.size)
                    gameScene.scaleMode = .resizeFill
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    view.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
}
