//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    var didNotRunYet = true
    
    var gameScene: GameScene! // SCNScene

    var panGesture = UIPanGestureRecognizer.self()
    var tapGesture = UITapGestureRecognizer.self()
    var tapRecognizer = UITapGestureRecognizer.self()
    
    var overlayScene = OverlayScene(size: CGSize(width: 0,height: 0))

    var touchCount = 0.0
    
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
 
        //Configure the scene
        gameScene = GameScene()

        //Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.blackColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Configure the overlay SKScene
        overlayScene = OverlayScene(size: self.view.bounds.size)
        sceneView.overlaySKScene = overlayScene

        panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        overlayScene.board.playHandler = addGestures
        
        gameScene.cubeRestHandler = cubeRestHandler
    }
        
    func addGestures() {
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        
        let translationY = gesture.translationInView(self.view).y
        let translationX = gesture.translationInView(self.view).x
        
        if touchCount < 2 {
            if translationY < -100 {
                for node in gameScene.geometryNodes.cubesNode.childNodes {
                    node.physicsBody!.applyTorque(SCNVector4(1,1,1,(translationY/400-1)), impulse: true) // Perfect spin
                    node.physicsBody!.applyForce(SCNVector3(translationX/17,(-translationY/130)+9,(translationY/5)-11), impulse: true) //MIN (0,17,-31) MAX (0,21,-65)
                }
                
                touchCount+=1
            }
        } else if touchCount == 2 {
            gameScene.winningSquares = []
            gameScene.shouldCheckMovement = true
            
        }
    }

    func cubeRestHandler() {
        
        if didNotRunYet {
            
            touchCount = 0
            
            overlayScene.board.showBoard()
            self.view.gestureRecognizers = []
            
            for winningColor in gameScene.winningSquares {
                
                var row = Int()
                var column = Int()
                
                if winningColor == "Yellow" {
                    row = 1
                    column = 0
                } else if winningColor == "Cyan" {
                    row = 1
                    column = 1
                } else if winningColor == "Purple" {
                    row = 1
                    column = 2
                } else if winningColor == "Blue" {
                    row = 0
                    column = 0
                } else if winningColor == "Red" {
                    row = 0
                    column = 1
                } else if winningColor == "Green" {
                    row = 0
                    column = 2
                }
                
                overlayScene.board.getWiningSquares(row, column: column)
                
            }
            overlayScene.board.handleResults()
            
            
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.delayCubeRest()
            })
            //Note: triggerTime = 1000000000 (i.e. 1sec x 10^9)
            //Note: DISPATCH_TIME_NOW = 0
            
            didNotRunYet = false
        }
        
    }
    
    func delayCubeRest() {
        self.gameScene.geometryNodes.addCubesTo(self.gameScene.geometryNodes.cubesNode)
        self.gameScene.resetCubes()
        didNotRunYet = true
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func handleTap(gesture:UITapGestureRecognizer) {
        print("Screen Tapped")
    }
}