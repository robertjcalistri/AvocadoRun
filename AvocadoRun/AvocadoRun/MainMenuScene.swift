import SpriteKit
import Firebase

class MainMenuScene: SKScene {
    let playButton = SKLabelNode(text: "Play")
    let loginButton = SKLabelNode(text: "Login")
    let createAccountButton = SKLabelNode(text: "Create Account")
    var isLoggedIn = false
    
    func createAccount() {
        let alertController = UIAlertController(title: "Create Account", message: "Enter your email and password", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }

        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            // Create the user account when the "Create" button is tapped
            guard let emailTextField = alertController.textFields?.first,
                  let passwordTextField = alertController.textFields?.last,
                  let email = emailTextField.text,
                  let password = passwordTextField.text else {
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    // Show an error message if account creation fails
                    print("Error creating account: \(error.localizedDescription)")
                } else {
                    // Account created successfully
                    print("Account created successfully")
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)

        if let viewController = view?.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func login() {
        let alertController = UIAlertController(title: "Login", message: "Enter your email and password", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }

        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        let loginAction = UIAlertAction(title: "Login", style: .default) { _ in
            // Log in the user when the "Login" button is tapped
            guard let emailTextField = alertController.textFields?.first,
                  let passwordTextField = alertController.textFields?.last,
                  let email = emailTextField.text,
                  let password = passwordTextField.text else {
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    // Show an error message if login fails
                    print("Error logging in: \(error.localizedDescription)")
                    
                    // Display a pop-up about the login failure
                    let errorAlert = UIAlertController(title: "Login Failed", message: "Incorrect email or password. Please try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    errorAlert.addAction(okAction)
                    if let viewController = self.view?.window?.rootViewController {
                        viewController.present(errorAlert, animated: true, completion: nil)
                    }
                } else {
                    // Login successful
                    print("Login successful")
                    
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)

        if let viewController = view?.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }




    override func didMove(to view: SKView) {
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(playButton)

        loginButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(loginButton)

        createAccountButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(createAccountButton)
        
        if isLoggedIn {
            playButton.text = "Play"
        } else {
            playButton.text = "Login to Play"
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            if playButton.contains(location) {
                if let view = self.view {
                    let gameScene = GameScene(size: CGSize(width: 500, height: 1080))
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    view.presentScene(gameScene, transition: transition)
                }
            } else if loginButton.contains(location) {
                login()
            } else if createAccountButton.contains(location) {
                createAccount()
            }
        }
    }
}
