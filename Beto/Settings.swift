//
//  Settings.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Settings {
    fileprivate let layer: SKNode
    fileprivate let background: SKSpriteNode
    fileprivate let soundButton: ButtonNode
    fileprivate let musicButton: ButtonNode
    fileprivate let closeButton: ButtonNode
    
    init() {
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        background = SKSpriteNode(color: UIColor.black, size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        background.alpha = 0.0
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton_Large")
        closeButton.size = CGSize(width: 44, height: 45)
        
        var soundImage = "soundButton"
        var musicImage = "musicButton"
        
        if Audio.soundMuted {
            soundImage = "soundButton_mute"
        }
        
        if Audio.musicMuted {
            musicImage = "musicButton_mute"
        }
        
        soundButton = ButtonNode(defaultButtonImage: soundImage)
        soundButton.size = CGSize(width: 44, height: 45)
        
        musicButton = ButtonNode(defaultButtonImage: musicImage)
        musicButton.size = CGSize(width: 44, height: 45)
    }
    
    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlpha(to: 0.6, duration: 0.3)
        background.run(fadeIn)
        
        // Assign actions
        closeButton.action = close
        soundButton.action = toggleSoundButton
        musicButton.action = toggleMusicButton
        
        // Designate positions
        closeButton.position = CGPoint(x: 60, y: -100)
        soundButton.position = CGPoint(x: 0, y: -160)
        musicButton.position = CGPoint(x: 60, y: -160)
        
        // Add nodes to layer node
        layer.addChild(background)
        layer.addChild(closeButton)
        layer.addChild(soundButton)
        layer.addChild(musicButton)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.wait(forDuration: 0.5)
        
        soundButton.run(SKAction.removeFromParent())
        musicButton.run(SKAction.removeFromParent())
        closeButton.run(SKAction.removeFromParent())
        
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.run(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.run(actions)
    }
    
    func toggleSoundButton() {
        Audio.toggleSound()
        
        if Audio.soundMuted {
            soundButton.changeTexture("soundButton_mute")
        } else {
            soundButton.changeTexture("soundButton")
        }
    }
    
    func toggleMusicButton() {
        Audio.toggleMusic()
        
        if Audio.musicMuted {
            musicButton.changeTexture("musicButton_mute")
        } else {
            musicButton.changeTexture("musicButton")
        }
    }
    
    func presentMenuScene() {
        let transition = SKTransition.flipVertical(withDuration: 0.4)
        let menuScene = MenuScene(size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        menuScene.scaleMode = .aspectFill
        let skView = SKView()
        skView.presentScene(menuScene, transition: transition)
    }
}
