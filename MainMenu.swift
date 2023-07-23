//
//  MainMenu.swift
//  AvocadoRun
//
//  Created by Jocelyn Berrios on 7/22/23.
//

import SpriteKit
import FirebaseAuth

class MainMenu: SKScene {
    
    //Declare Nodes
    let backgroundImg = SKSpriteNode(imageNamed: "background")
    let gameTitle = SKLabelNode(fontNamed: "Impact")
    let startButton = SKSpriteNode(imageNamed: "start")
    let howToPlay = SKLabelNode(fontNamed: "Arial")
    let how2 = SKLabelNode(fontNamed: "Arial")
    let playerImg = SKSpriteNode(imageNamed: "avocadoGreeting")
    
    let loginButton = SKLabelNode(fontNamed: "Arial")
    let createAccountButton = SKLabelNode(fontNamed: "Arial")
    let loginError = SKLabelNode(fontNamed: "Arial")
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
    

        //Set the MainMenu Scene
        override func didMove(to view: SKView) {
            
            //Format and display Background
            backgroundImg.position = CGPoint(x: size.width / 2, y: size.height / 2)
            backgroundImg.zPosition = -1
            addChild(backgroundImg)
            
            //Format and display gameTitle
            gameTitle.text = "Avocado Run"
            gameTitle.fontSize = 100
            gameTitle.fontColor = SKColor.systemRed
            gameTitle.position = CGPoint(x: frame.midX, y: self.size.height * 0.75)
            gameTitle.zPosition = 1
            addChild(gameTitle)
            
            //Format and display loginButton
            loginButton.text = "Login"
            loginButton.fontColor = SKColor.magenta
            loginButton.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.62)
            addChild(loginButton)
            
            //Format and display createAccountButton
            createAccountButton.text = "Create Account"
            createAccountButton.fontColor = SKColor.magenta
            createAccountButton.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.54)
            addChild(createAccountButton)
            
            //Format and display startButton
            startButton.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.42)
            startButton.zPosition = 1
           // addChild(startButton)
            
            //Format and display howToPlay title
            howToPlay.text = "How to Play: "
            howToPlay.fontSize = 23
            howToPlay.fontColor = SKColor.darkGray
            howToPlay.position = CGPoint(x: frame.midX, y: self.size.height*0.30)
            howToPlay.zPosition = 1
            addChild(howToPlay)
            
            //Format and display howToPlay line 2 (how2)
            how2.text = "Tap the screen to jump and avoid falling to the ground"
            how2.fontSize = 20
            how2.fontColor = SKColor.darkGray
            how2.position = CGPoint(x: frame.midX, y: self.size.height*0.28)
            how2.zPosition = 1
            addChild(how2)
            
            
            //Format and display playerImg
            playerImg.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
            playerImg.zPosition = 1
            addChild(playerImg)
            
            //Determins if player is logged in it will display start button, otherwise they will get a loginError
            if isLoggedIn {
                addChild(startButton)
            } else
            {
                loginError.text = " Must Log in to play"
                loginError.fontColor = SKColor.red
                loginError.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.42)
                loginError.zPosition = 1
            }    
            
        }//End of didMove
            
        // touchBegan function: sets up touch behavior. When startButton is pressed, enter GameScene.
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if let touch = touches.first {
                var location = touch.location(in: self)
                
                if startButton.contains(location) {
                    if let view = self.view {
                        let gameScene = GameScene(size: CGSize(width: 560, height: 1140))
                        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                        view.presentScene(gameScene, transition: transition)
                        gameScene.scaleMode = .resizeFill
                        
                    }
                } else if loginButton.contains(location) {
                    login()
                } else if createAccountButton.contains(location) {
                    createAccount()
                }
            }
            
        
        
    }//End of touchesBegan
   
}//End of MainMenu
