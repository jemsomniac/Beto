//
//  OpenRewardsNode.swift
//  Beto
//
//  Created by Jem on 8/20/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class OpenRewardsNode: DropdownNode {
    private var prizeCount: Int
    private var claimButton: ButtonNode
    private var claimedCount = 0
    
    var claimRewardsHandler: (() -> ())?
    
    init(diceKey: RewardsDiceKey) {
        switch diceKey {
        case .Bronze:
            prizeCount = 3
        case .Silver:
            prizeCount = 3
        case .Gold:
            prizeCount = 3
        case .Platinum:
            prizeCount = 5
        case .Diamond:
            prizeCount = 5
        case .Ruby:
            prizeCount = 5
        }
        
        let container = SKSpriteNode()
        
        claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
        claimButton.hidden = true
        
        container.addChild(claimButton)
        
        super.init(container: container)
        
        // Add actions
        claimButton.action = handleClaimRewards
        
        let imageName = diceKey.rawValue.lowercaseString + "Reward_large"
        
        for pos in 0...prizeCount-1 {
            let button = ButtonNode(defaultButtonImage: imageName)
            button.position = pointForPosition(pos)
            button.action = {
                let prize = self.generatePrize()
                
                let sprite = SKSpriteNode(imageNamed: prize.type)
                sprite.position = self.pointForPosition(pos)
                
                let label = SKLabelNode(text: "+\(prize.amount)")
                label.fontName = Constant.FontNameExtraBold
                label.fontSize = 18
                label.position = CGPoint(x: 10, y: -20)
                
                let labelShadow = label.createLabelShadow()
                
                sprite.addChild(labelShadow)
                sprite.addChild(label)
                container.addChild(sprite)
                
                button.removeActionForKey("wobble")
                button.action = {}
                button.removeFromParent()
                
                self.claimedCount += 1
                
                if self.claimedCount == self.prizeCount {
                    self.claimButton.hidden = false
                }
            }
            
            let rotR = SKAction.rotateByAngle(0.15, duration: 0.2)
            let rotL = SKAction.rotateByAngle(-0.15, duration: 0.2)
            let pause = SKAction.rotateByAngle(0, duration: 1.0)
            let cycle = SKAction.sequence([pause, rotR, rotL, rotL, rotR])
            let wobble = SKAction.repeatActionForever(cycle)
            button.runAction(wobble, withKey: "wobble")
            
            container.addChild(button)
        }
    }
    
    func handleClaimRewards() {
        close()
        claimRewardsHandler!()
    }
    
    func generatePrize() -> (type: String, amount: Int) {
        var rewardType = ""
        var amount = 0
        
        var rand = Int(arc4random_uniform(100)) + 1
        
        // DELETE: Temp - Resolve reward type
        if rand <= 20 {
            rewardType = "doubleDice"
        } else if rand <= 40 {
            rewardType = "doublePayout"
        } else if rand <= 60 {
            rewardType = "triplePayout"
        } else if rand <= 79{
            rewardType = "lifeline"
        } else if rand <= 98 {
            rewardType = "rewind"
        } else {
            rewardType = "starCoin"
        }
        
        rand = Int(arc4random_uniform(100)) + 1
        
        // DELETE: Temp - Resolve reward amount
        if rand <= 40 {
            amount = 1
        } else if rand <= 70 {
            amount = 2
        } else if rand <= 85 {
            amount = 3
        } else if rand <= 95 {
            amount = 4
        } else {
            amount = 5
        }
        
        if rewardType == "starCoin" {
            GameData.addStarCoins(amount)
        } else {
            GameData.addPowerUpCount(rewardType, num: amount)
        }
        
        GameData.save()
        
        return (rewardType, amount)
    }
    
    func pointForPosition(position: Int) -> CGPoint {
        let xPosition: CGFloat = 60
        let yPosition: CGFloat = 80

        if position == 0 {
            return CGPoint(x: 0, y: yPosition)
        } else if position == 1 {
            return CGPoint(x: -xPosition, y: -yPosition)
        } else if position == 2 {
            return CGPoint(x: xPosition, y: -yPosition)
        } else if position == 3 {
            return CGPoint(x: -xPosition * 1.5, y: 0)
        } else if position == 4 {
            return CGPoint(x: xPosition * 1.5, y: 0)
        } else {
            return CGPoint(x: 0, y: 0) // Failsafe, should not execute
        }
    }
}

