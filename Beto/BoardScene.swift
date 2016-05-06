//
//  BoardScene.swift
//  Beto
//
//  Created by Jem on 4/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene {
    var board: Board!
    var gameHUD: GameHUD!
    var boardLayer: SKNode!
    var gameHUDLayer: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
                
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameData.showUnlockedCoinHandler = showUnlockedCoin
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.frame.size
        
        board = Board(scene: self)
        boardLayer = board.createLayer()
        
        gameHUD = GameHUD(scene: self)
        gameHUDLayer = gameHUD.createLayer()
        
        board.toggleReplayButton()
        
        if !Audio.musicMuted {
            runAction(SKAction.waitForDuration(0.5), completion: {
                self.addChild(Audio.backgroundMusic)
            })
        }
        
        addChild(background)
        addChild(gameHUDLayer)
        addChild(boardLayer)
    }
        
    func showUnlockedCoin() {
        let reward = Rewards()
        addChild(reward.createLayer())
    }
    
    func presentGameScene() {
        self.view!.window!.rootViewController!.performSegueWithIdentifier("showGameScene", sender: self)
    }
    
    func presentMenuScene() {
        Audio.backgroundMusic.removeFromParent()
        
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .AspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
}

