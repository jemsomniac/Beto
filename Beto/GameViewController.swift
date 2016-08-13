//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    var gameScene: GameScene!
    var boardScene: BoardScene!
    
    // HUD
    private var gameHUDView: UIImageView!
    private var backButton: UIButton!
    private var highscoreView: UIImageView!
    private var coinsView: UIImageView!
    private var highscoreLabel: UILabel!
    private var coinsLabel: UILabel!

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
        
        gameHUDView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320 * Constant.ScaleFactor, height: 38 * Constant.ScaleFactor))
        gameHUDView.image = UIImage(named: "gameSceneHUD")
        self.view.addSubview(gameHUDView)
        
        backButton = UIButton(frame: CGRect(x: 5, y: 7, width: 60 * Constant.ScaleFactor, height: 25 * Constant.ScaleFactor))
        backButton.setBackgroundImage(UIImage(named: "backButton"), forState: .Normal)
        backButton.contentMode = .ScaleAspectFill
        backButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let font = UIFont(name: "Futura-CondensedMedium", size: 14 * Constant.ScaleFactor)
        
        highscoreLabel = UILabel()
        highscoreLabel.frame = CGRect(x: 110 * Constant.ScaleFactor, y: 9 * Constant.ScaleFactor, width: 80  * Constant.ScaleFactor, height: 18  * Constant.ScaleFactor)
        highscoreLabel.text = "\(GameData.highscore)"
        highscoreLabel.font = font
        highscoreLabel.textColor = UIColor.whiteColor()
        highscoreLabel.textAlignment = .Center
        self.view.addSubview(highscoreLabel)
        
        let coins = GameData.coins - boardScene.getWagers()
        
        coinsLabel = UILabel()
        coinsLabel.frame = CGRect(x: 220 * Constant.ScaleFactor, y: 9 * Constant.ScaleFactor, width: 80  * Constant.ScaleFactor, height: 18  * Constant.ScaleFactor)
        coinsLabel.text = "\(coins)"
        coinsLabel.font = font
        coinsLabel.textColor = UIColor.whiteColor()
        coinsLabel.textAlignment = .Center
        self.view.addSubview(coinsLabel)
        
        if boardScene.activePowerUp != "" {
            let activePowerUpView = UIImageView(frame: CGRect(x: 10, y: gameHUDView.frame.height + 5, width: 48 * Constant.ScaleFactor, height: 48 * Constant.ScaleFactor))
            activePowerUpView.image = UIImage(named: boardScene.activePowerUp)
            activePowerUpView.contentMode = .TopLeft
            self.view.addSubview(activePowerUpView)
        }
        
        // Configure the Game scene
        var diceType: DiceType!
        
        switch(boardScene.activePowerUp) {
        case PowerUpKey.doublePayout.rawValue:
            diceType = .DoublePayout
        case PowerUpKey.triplePayout.rawValue:
            diceType = .TriplePayout
        case PowerUpKey.doubleDice.rawValue:
            diceType = .DoubleDice
        default:
            diceType = .Default
        }
        
        gameScene = GameScene(dice: diceType)
        gameScene.resolveGameplayHandler = { [unowned self] in self.handleResolveGameplay() }
        
        // Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.clearColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Configure the background
        gameScene.background.contents = UIImage(named: GameData.theme.background)
        
        // Configure the gestures
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        let translationY = gesture.translationInView(self.view).y
        let translationX = gesture.translationInView(self.view).x
        
        if touchCount < 2 {
            if translationY < -100 {
                for node in gameScene.getDice() {
                    node.physicsBody!.applyTorque(SCNVector4(1,1,1,(translationY/400-1)), impulse: true) // Perfect spin
                    node.physicsBody!.applyForce(SCNVector3(translationX/17,(-translationY/130)+9,(translationY/5)-11), impulse: true) // MIN (0,17,-31) MAX (0,21,-65)
                }
                
                touchCount += 1
             
                backButton.enabled = false
            }
        } else if touchCount == 2 {
            gameScene.shouldCheckMovement = true
        }
    }
    
    func handleResolveGameplay() {        
        // Subtract wagers from GameData
        GameData.subtractCoins(boardScene.getWagers())
        
        GameData.incrementGamesPlayed()
        
        var winningColors: [Color] = []
        var didWin = false
        
        for node in gameScene.getDice() {
            let winningColor = gameScene.getWinningColor(node)
            let didPayout = boardScene.payout(winningColor)
            
            if !didWin {
                didWin = didPayout
            }
            
            if didPayout && !winningColors.contains(winningColor) {
                GameData.incrementWinCount(winningColor)
                winningColors.append(winningColor)
            }
            
            gameScene.animateRollResult(node, didWin: didPayout)

            delay(1.0) {}
        }
        
        boardScene.resolveWagers(didWin)
        boardScene.toggleReplayButton()
        
        GameData.subtractPowerUpCount(boardScene.activePowerUp, num: 1)
        boardScene.deactivatePowerUpButtonPressed()
        
        if didWin {
            let num = 4 - boardScene.squaresSelectedCount
                        
            GameData.incrementRewardChance(num)
            boardScene.resolveRandomReward()
        } else {
            GameData.resetRewardChance()
        }
        
        boardScene.resetSquaresSelectedCount()
        
        GameData.save()
        
        delay(1.0) {
            self.dismissViewControllerAnimated(true, completion: self.boardScene.showUnlockedNodes)
        }
    }
        
    func buttonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}

