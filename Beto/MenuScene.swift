//
//  MenuScene.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
            
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.size = self.frame.size
        addChild(background)
        
        // Start Game Button
        let startGameButton = ButtonNode(defaultButtonImage: "startGame", activeButtonImage: "startGame_active")
        startGameButton.size = CGSize(width: 86, height: 103)
        startGameButton.action = presentBoardScene
        
        let rotR = SKAction.rotateByAngle(0.15, duration: 0.2)
        let rotL = SKAction.rotateByAngle(-0.15, duration: 0.2)
        let pause = SKAction.rotateByAngle(0, duration: 1.0)
        let cycle = SKAction.sequence([pause, rotR, rotL, rotL, rotR])
        let wobble = SKAction.repeatActionForever(cycle)
        startGameButton.runAction(wobble, withKey: "wobble")
        
        addChild(startGameButton)
        
        // Customize Button
        let customizeButton = ButtonNode(defaultButtonImage: "customizeButton")
        customizeButton.size = CGSize(width: 44, height: 45)
        customizeButton.position = CGPoint(x: -60, y: -100)
        addChild(customizeButton)
        
        // Achievements Button
        let achievementsButton = ButtonNode(defaultButtonImage: "achievementsButton")
        achievementsButton.size = CGSize(width: 44, height: 45)
        achievementsButton.position = CGPoint(x: 0, y: -100)
        achievementsButton.action = displayAchievements
        addChild(achievementsButton)
        
        // Settings Button
        let settingsButton = ButtonNode(defaultButtonImage: "settingsButton")
        settingsButton.size = CGSize(width: 44, height: 45)
        settingsButton.position = CGPoint(x: 60, y: -100)
        settingsButton.action = displaySettings
        addChild(settingsButton)
    }
    
    func presentBoardScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let boardScene = BoardScene(size: self.size)
        boardScene.scaleMode = .AspectFill
    
        view!.presentScene(boardScene, transition: transition)
    }
    
    func displayAchievements() {
        let achievements = Achievements()
        let layer = achievements.createLayer()
        
        addChild(layer)
    }
    
    func displaySettings() {
        let settings = Settings()
        
        let layer = settings.createLayer()
        addChild(layer)
    }
}

