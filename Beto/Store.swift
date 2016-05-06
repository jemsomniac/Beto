//
//  Store.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Store {
    private let layer: SKNode
    private let background: SKSpriteNode
    private let placeHolder: SKSpriteNode
    private let closeButton: ButtonNode
        
    init() {
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        background.alpha = 0.0
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        
        placeHolder = SKSpriteNode(imageNamed: "buyCoinsPlaceholder")
    }
    
    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        placeHolder.runAction(actions)
        
        // Assign actions
        closeButton.action = close
        
        // Designate positions
        closeButton.position = CGPoint(x: 140, y: 190)
        placeHolder.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        // Add nodes
        placeHolder.addChild(closeButton)
        layer.addChild(background)
        layer.addChild(placeHolder)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.Height, duration: 0.4)
        let exitActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        placeHolder.runAction(exitActions)
        closeButton.runAction(exitActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
}