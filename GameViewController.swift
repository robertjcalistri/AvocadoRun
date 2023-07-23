//
//  GameViewController.swift
//  AvocadoRun
//
//  Created by Jocelyn Berrios on 7/19/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MainMenuScene(size: CGSize(width: 560, height: 1140))
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        var shouldAutorotate: Bool {
            return true
        }
        
        var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .allButUpsideDown
            } else {
                return .all
            }
        }
        
        var prefersStatusBarHidden: Bool {
            return true
        }
    }
}
