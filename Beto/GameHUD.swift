//
//  GameHUD.swift
//  Beto
//
//  Created by Jem on 2/25/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class GameHUD {
    let layer = SKNode()
    
    let scene: SKScene
    let gameHUD: SKSpriteNode
    let menuButton: ButtonNode
    let coinsNode: ButtonNode
    let highscoreNode: ButtonNode
    let coinsLabel: SKLabelNode
    let highscoreLabel: SKLabelNode
    
    init(scene: SKScene) {
        self.scene = scene
        
        gameHUD = SKSpriteNode(imageNamed: "gameHUD")
        gameHUD.size = CGSize(width: 320, height: 38)
        
        // Menu Node
        menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        menuButton.position = CGPoint(x: (-gameHUD.size.width + menuButton.size.width + Constant.Margin) / 2 , y: 0)
        
        // Coins Node
        coinsNode = ButtonNode(defaultButtonImage: "buyCoinsButton")
        coinsNode.size = CGSize(width: 100, height: 25)
        coinsNode.position = CGPoint(x: (gameHUD.size.width - coinsNode.size.width) / 2 - Constant.Margin, y: 0)
        
        coinsLabel = SKLabelNode(text: "\(GameData.coins)")
        coinsLabel.fontName = Constant.FontName
        coinsLabel.fontSize = 14
        coinsLabel.horizontalAlignmentMode = .Center
        coinsLabel.verticalAlignmentMode = .Center
        
        // Highscore Node
        highscoreNode = ButtonNode(defaultButtonImage: "highscoreButton")
        highscoreNode.size = CGSize(width: 100, height: 25)
        highscoreNode.position = CGPoint(x: coinsNode.position.x - (highscoreNode.size.width + Constant.Margin), y: 0)
        
        highscoreLabel = SKLabelNode(text: "\(GameData.highscore)")
        highscoreLabel.fontName = Constant.FontName
        highscoreLabel.fontSize = 14
        highscoreLabel.horizontalAlignmentMode = .Center
        highscoreLabel.verticalAlignmentMode = .Center
    }

    func createLayer() -> SKNode {
        gameHUD.position = CGPoint(x: 0, y: (ScreenSize.height - gameHUD.size.height) / 2)

        // Add actions
        menuButton.action = presentMenuScene
        highscoreNode.action = displayAchievements
        coinsNode.action = displayStore
        
        // Add nodes to gameHUD
        coinsNode.addChild(coinsLabel)
        highscoreNode.addChild(highscoreLabel)
        
        gameHUD.addChild(menuButton)
        gameHUD.addChild(highscoreNode)
        gameHUD.addChild(coinsNode)
        
        layer.addChild(gameHUD)
        
        return layer
    }
    
    func presentMenuScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: scene.size)
        menuScene.scaleMode = .AspectFill
        
        scene.view!.presentScene(menuScene, transition: transition)
    }
    
    func displayStore() {
        let store = Store()
        let layer = store.createLayer()

        scene.addChild(layer)
        
        // DELETE: Placeholder for In-App Purchases
        GameData.coins += 20
        coinsLabel.text = "\(GameData.coins)"
        
        if GameData.coins > GameData.highscore {
            GameData.highscore = GameData.coins
            highscoreLabel.text = "\(GameData.highscore)"

            GameData.didUnlockCoin()
        }
        
        GameData.saveGameData()
    }
    
    func displayAchievements() {
        let achievements = Achievements()
        let layer = achievements.createLayer()
        
        scene.addChild(layer)
    }
}