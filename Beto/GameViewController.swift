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
    
    var gameScene: GameScene!
    var boardScene: BoardScene!

    var panGesture = UIPanGestureRecognizer.self()
    var tapGesture = UITapGestureRecognizer.self()
    var tapRecognizer = UITapGestureRecognizer.self()
    
    var touchCount = 0.0
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Configure the scene
        gameScene = GameScene()
        gameScene.cubeRestHandler = handleCubeRest
        gameScene.endGameplayHandler = handleEndGameplay

        // Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.blackColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Configure the background
        let sceneMaterials = SCNMaterial()
        sceneMaterials.diffuse.contents = boardScene
        sceneMaterials.locksAmbientWithDiffuse = false
        sceneMaterials.doubleSided = true
        gameScene.geometryNodes.floorNode.geometry!.materials = [sceneMaterials]
        gameScene.geometryNodes.floorNode.scale.y = -1

        // Configure the gestures
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePan(_:)))
        view.addGestureRecognizer(panGesture)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        // Subtract wagers from GameData
        GameData.coins -= boardScene.board.getWagers()
        
        // DELETE 
        print(GameData.coins)
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
                
                touchCount += 1
            }
        } else if touchCount == 2 {
            gameScene.shouldCheckMovement = true
        }
    }

    func handleCubeRest(winningColor: Color) {
        
        // DELETE
        print("handling \(winningColor.name)")
        
        boardScene.board.payout(winningColor)
        
        // DELETE 
        print("finished payout")
    }
    
    func handleEndGameplay() {
        //DELETE
        print("about to resolve")
        
        boardScene.board.resolveWagers()
        
        touchCount = 0
        self.view.gestureRecognizers = []
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1) //Note: Delay needed for cubes to be removed first
        
        print("resolved complete")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(),
                       { () -> Void in
                        self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        
        print("dismissed controller")
        
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime * 2), dispatch_get_main_queue(),
        //                { () -> Void in
        //                    self.gameScene.geometryNodes.addCubesTo(self.gameScene.geometryNodes.cubesNode)
        //                    self.gameScene.resetCubes()
        //                })
        
        //NOTE: Use to crash from dismissing the viewController too early, but now crashes after 5 throws ("Message from debugger: Terminated due to memory issue")
    }
    
    func handleTap(gesture:UITapGestureRecognizer) {
        //TODO: Cancel gesture
    }
}