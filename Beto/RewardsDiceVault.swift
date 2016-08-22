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
        vault.size = CGSize(width: 304, height: 211)
        
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        
        super.init(container: vault)
        
        // Designate positions
        vault.position = CGPoint(x: 0, y: ScreenSize.Height)
        closeButton.position = CGPoint(x: 140, y: 100)
        
        // Add actions
        closeButton.action = close
        
        // Add nodes
        vault.addChild(closeButton)
        
        var position = 0
        
        for key in RewardsDiceKey.allValues {
            let button = RewardsDice(key: key, count: GameData.rewardsDice[key.rawValue]!)
            button.position = pointForPosition(position)
            button.openRewardsDiceHandler = handleOpenRewards
            
            vault.addChild(button)
            
            position += 1
        }
    }
    
    func handleOpenRewards(dice: RewardsDice) {
        openRewardsDiceHandler!(dice)
    }
    
    func pointForPosition(position: Int) -> CGPoint {
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

