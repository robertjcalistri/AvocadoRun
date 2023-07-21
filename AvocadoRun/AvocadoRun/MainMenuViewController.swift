import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Create and add a start button
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Game", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        // Center the button in the view
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func startButtonTapped() {
        // Create and present the GameScene
        let skView = SKView(frame: view.frame)
        let gameScene = GameScene(size: skView.bounds.size)
        skView.presentScene(gameScene)

        // Configure the SKView properties (e.g., show FPS, node count, etc.)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        // Present the SKView as the main view of the MainMenuViewController
        view = skView
    }
}
