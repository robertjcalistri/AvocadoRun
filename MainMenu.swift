//
//  MainMenu.swift
//  AvocadoRun
//
//  Created by Jocelyn Berrios on 7/21/23.
//

import SwiftUI
import UIKit
import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    let Menubackground = SKSpriteNode(imageNamed: "Menubackground")
    let startButton = SKSpriteNode(imageNamed: "Start")
    let settings = SKSpriteNode(imageNamed: "Settings")
    
    
    override func didMove(to view: SKView) {
        
        // background image
        addChild(Menubackground)
        
        //settings button
        settings.position = CGPoint(x: 0, y: 100)
        addChild(settings)
        
        // Start button
        startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(startButton)
        
        
        
        
        
        
        // when user touches screen
        //override func touchesBegan(_ touches: NSSet, with event: UIEvent) {
        // for touch: AnyObject in touches {
        
        
        
        
        
        //}
        
        //
        //override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //}
        
        
    }
}
