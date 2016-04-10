//
//  MenuScene.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let placeBetSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
    let clearBetSound = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
    let winSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let lostSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
    
    var startGameButton: StartGameNode?

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.size = self.frame.size
        addChild(background)
        
  
        let startGameButton = StartGameNode(defaultButtonImage: "startGame", activeButtonImage: "startGame_active")
        startGameButton.size = CGSize(width: 86, height: 103)
        startGameButton.action = presentBoardScene
        addChild(startGameButton)
        
        let customizeButton = ButtonNode(defaultButtonImage: "customizeButton")
        customizeButton.size = CGSize(width: 44, height: 45)
        customizeButton.position = CGPoint(x: -60, y: -100)
        addChild(customizeButton)
        
        let achievementsButton = ButtonNode(defaultButtonImage: "achievementsButton")
        achievementsButton.size = CGSize(width: 44, height: 45)
        achievementsButton.position = CGPoint(x: 0, y: -100)
        achievementsButton.action = displayAchievements
        addChild(achievementsButton)
        
        let settingsButton = ButtonNode(defaultButtonImage: "settingsButton")
        settingsButton.size = CGSize(width: 44, height: 45)
        settingsButton.position = CGPoint(x: 60, y: -100)
        settingsButton.action = displaySettings
        addChild(settingsButton)
    }
    
//    func presentGameScene() {
//        self.view!.window!.rootViewController!.performSegueWithIdentifier("showGameScene", sender: self)
//    }
//    
    
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

