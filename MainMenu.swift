//
//  MainMenu.swift
//  AvocadoRun
//
//  Created by Jocelyn Berrios on 7/22/23.
//

import SpriteKit

class MainMenu: SKScene {

    //Declare Nodes
    let backgroundImg = SKSpriteNode(imageNamed: "background")
    let gameTitle = SKLabelNode(fontNamed: "Impact")
    let startButton = SKSpriteNode(imageNamed: "Start")
    let howToPlay = SKLabelNode(fontNamed: "Arial")
    let how2 = SKLabelNode(fontNamed: "Arial")
    let how3 = SKLabelNode(fontNamed: "Arial")
    let playerImg = SKSpriteNode(imageNamed: "avocado")
    
    //Set the MainMenu Scene
    override func didMove(to view: SKView) {
        
        //Format and add Background  
        backgroundImg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImg.zPosition = -1
        addChild(backgroundImg)
        
        //Format and add gameTitle
        gameTitle.text = "Avocado Run"
        gameTitle.fontSize = 100
        gameTitle.fontColor = SKColor.systemRed
        gameTitle.position = CGPoint(x: frame.midX, y: self.size.height * 0.7)
        gameTitle.zPosition = 1
        addChild(gameTitle)
        
        //Format and add startButton
        startButton.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.5)
        startButton.zPosition = 1
        addChild(startButton)
        
        //Format and add howToPlay title
        howToPlay.text = "How to Play:"
        howToPlay.fontSize = 30
        howToPlay.fontColor = SKColor.darkGray
        howToPlay.position = CGPoint(x: frame.midX, y: self.size.height*0.36)
        howToPlay.zPosition = 1
        addChild(howToPlay)

        //Format and add howToPlay line 2 (how2) 
        how2.text = "Tap the screen to jump"
        how2.fontSize = 25
        how2.fontColor = SKColor.darkGray
        how2.position = CGPoint(x: frame.midX, y: self.size.height*0.33)
        how2.zPosition = 1
        addChild(how2)

        //Format and add howToPlay line 3 (how3) 
        how3.text = "Avoid falling to the ground"
        how3.fontSize = 25
        how3.fontColor = SKColor.darkGray
        how3.position = CGPoint(x: frame.midX, y: self.size.height*0.31)
        how3.zPosition = 1
        addChild(how3)
        
       //Format and add playerImg 
        playerimg.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        playerimg.zPosition = 1
        addChild(playerimg)
        
    }//End of didMove
    
    // Create function for MainMenu touch behavior. When startButton is pressed, enter GameScene.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {   
            let location = touch.location(in: self)
            
            if startButton.contains(location) {
                if let view = self.view { 
                    let gameScene = GameScene(size: CGSize(width: 560, height: 1140))
                    let transition = SKTransition.fade(withDuration: 0.50)
                    view.presentScene(gameScene, transition: transition)
                }
            }
        }
    }//End of touchesBegan
}//End of MainMenu
