//
//  MenuViewController.swift
//  Beto
//
//  Created by Jem on 3/10/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    var scene: MenuScene!
    var board: Board!
    
    @IBAction func unwindFromGameViewController(segue: UIStoryboardSegue) {
    
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let boardScene = sender as? BoardScene {
            if segue.identifier == "showGameScene" {
                let destinationVC = segue.destinationViewController as! GameViewController
                destinationVC.boardScene = boardScene
            }
        }
    }

}
