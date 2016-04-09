//
//  Achievements.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class Achievements {
    private let layer = SKNode()
    
    var background: SKSpriteNode
    var placeHolder: SKSpriteNode
    var closeButton: ButtonNode
        
    init() {
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        background.alpha = 0.0
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        // DELETE: Change position to dynamic values
        closeButton.position = CGPoint(x: 140, y: 190)
        
        placeHolder = SKSpriteNode(imageNamed: "achievementsPlaceholder")
        placeHolder.position = CGPoint(x: 0, y: ScreenSize.height)

    }
    
    func createLayer() -> SKNode {
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        placeHolder.runAction(actions)
        
        closeButton.action = close

        placeHolder.addChild(closeButton)
        
        layer.addChild(background)
        layer.addChild(placeHolder)
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.height, duration: 0.4)
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