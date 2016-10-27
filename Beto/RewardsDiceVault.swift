//
//  RewardsDiceVault.swift
//  Beto
//
//  Created by Jem on 8/20/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class RewardsDiceVault: DropdownNode {
    var openRewardsDiceHandler: ((RewardsDice) -> ())?
    
    init() {
        let vault = SKSpriteNode(imageNamed: "rewardsDiceVault")
        vault.position = CGPoint(x: 0, y: ScreenSize.Height)
        vault.size = CGSize(width: 304, height: 211)
        
        super.init(container: vault)
        
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.position = CGPoint(x: 140, y: 100)
        closeButton.size = CGSize(width: 44, height: 45)
        closeButton.action = close
        
        let infoOverlay = ButtonNode(defaultButtonImage: "overlay")
        infoOverlay.action = { infoOverlay.removeFromParent() }
        
        let infoSprite = SKSpriteNode(imageNamed: "rewardsDiceInfo")
        
        infoOverlay.addChild(infoSprite)
        
        let infoButton = ButtonNode(defaultButtonImage: "infoButton")
        infoButton.position = CGPoint(x: 120, y: -75)
        infoButton.action = {
            infoOverlay.alpha = 0.0
            
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
            infoOverlay.run(fadeIn)
            
            vault.addChild(infoOverlay)
        }
 
        let shopButton = ButtonNode(defaultButtonImage: "shopButton")
        shopButton.position = CGPoint(x: -110, y: -75)
        shopButton.action = {
            let shop = BetoShop(type: .RewardsDice)
            vault.addChild(shop.createLayer())
        }
        
        // Add nodes
        vault.addChild(closeButton)
        vault.addChild(infoButton)
        vault.addChild(shopButton)
        
        var position = 0
        
        for key in RewardsDiceKey.allValues {
            let button = RewardsDice(key: key, count: GameData.rewardsDice[key.rawValue]!)
            button.position = pointForPosition(position)
            button.openRewardsDiceHandler = handleOpenRewards
            
            vault.addChild(button)
            
            position += 1
        }
    }
    
    func handleOpenRewards(_ dice: RewardsDice) {
        openRewardsDiceHandler!(dice)
    }
    
    func pointForPosition(_ position: Int) -> CGPoint {
        var column = 0
        var row = 0
        
        // Position squares based on a 2x3 grid
        if position <= 2 {
            column = position
        } else  {
            row = 1
            column = position - 3
        }
        
        let xPosition: CGFloat = 80
        let yPosition: CGFloat = 50
        
        let offsetX = -xPosition + (xPosition * CGFloat(column))
        let offsetY = 33 - (yPosition * CGFloat(row))
        
        return CGPoint(x: offsetX, y: offsetY)
    }
}

