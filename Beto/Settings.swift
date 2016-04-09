//
//  Settings.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class Settings {
    private let layer = SKNode()
    
    var background: SKSpriteNode
    var soundButton: ButtonNode
    var musicButton: ButtonNode
    var closeButton: ButtonNode
    
    var changeBetValueHandler: (() -> ())?
    
    init() {
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        background.alpha = 0.0
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        closeButton.position = CGPoint(x: 60, y: -100)
        
        soundButton = ButtonNode(defaultButtonImage: "soundButton")
        soundButton.size = CGSize(width: 44, height: 45)
        soundButton.position = CGPoint(x: 0, y: -160)
        
        musicButton = ButtonNode(defaultButtonImage: "musicButton")
        musicButton.size = CGSize(width: 44, height: 45)
        musicButton.position = CGPoint(x: 60, y: -160)
    }
    
    func createLayer() -> SKNode {
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        closeButton.action = close
        soundButton.action = toggleSound
        musicButton.action = toggleMusic
        
        layer.addChild(background)
        layer.addChild(closeButton)
        layer.addChild(soundButton)
        layer.addChild(musicButton)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        soundButton.runAction(SKAction.removeFromParent())
        musicButton.runAction(SKAction.removeFromParent())
        closeButton.runAction(SKAction.removeFromParent())
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
    
    func toggleSound() {
        soundButton.changeTexture("soundButton_mute")
    }
    
    func toggleMusic() {
        musicButton.changeTexture("musicButton_mute")
    }
}