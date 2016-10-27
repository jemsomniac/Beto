//
//  BuyStarCoinsNode.swift
//  Beto
//
//  Created by Jem on 10/26/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BuyStarCoinsNode: SKNode {
    var count: Int
    var bonusDice: [RewardsDiceKey]
    var price: String //DELETE: Temp? Might have to change
    var buyButton: ButtonNode
    var priceLabel: SKLabelNode
    
    init(count: Int, bonusDice: [RewardsDiceKey], price: String) {
        self.count = count
        self.bonusDice = bonusDice
        self.price = price
        
        // Buy button
        buyButton = ButtonNode(defaultButtonImage: "buyButton")
        buyButton.position = CGPoint(x: 80, y: 10)
        
        // Configure price
        let titleLabel = SKLabelNode(text: "PRICE:")
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 65, y: -20)
        
        let titleShadow = titleLabel.createLabelShadow()
        
        priceLabel = SKLabelNode(text: price)
        priceLabel.fontName = Constant.FontNameCondensed
        priceLabel.fontColor = UIColor.darkGray
        priceLabel.fontSize = 14
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 90, y: -20)
        
        let plusLabel = SKLabelNode(text: "+")
        plusLabel.fontName = Constant.FontNameExtraBold
        plusLabel.fontColor = UIColor.white
        plusLabel.fontSize = 20
        plusLabel.position = CGPoint(x: -46, y: -10)

        let plusShadow = plusLabel.createLabelShadow()
        
        super.init()
        
        let container = SKSpriteNode(imageNamed: "dropNodeCellBackground")
        container.size = CGSize(width: 276, height: 60)
        
        let starCoinsNode = SKSpriteNode(imageNamed: "starCoinsCountBackground")
        starCoinsNode.position = CGPoint(x: -90, y: 0)
        
        let countLabel = SKLabelNode(text: "\(count)")
        countLabel.fontName = Constant.FontNameCondensed
        countLabel.fontColor = UIColor.white
        countLabel.fontSize = 14
        countLabel.horizontalAlignmentMode = .left
        countLabel.verticalAlignmentMode = .center
        countLabel.position = CGPoint(x: 5, y: 0)
        
        starCoinsNode.addChild(countLabel)
        
        var xPosition = 12
        
        for diceKey in bonusDice {
            let imageName = "\(diceKey.rawValue.lowercased())Reward"

            let node = SKSpriteNode(imageNamed: imageName)
            node.position = CGPoint(x: xPosition, y: 0)
            
            xPosition -= 16
            
            container.addChild(node)
        }
        
        container.addChild(starCoinsNode)
        container.addChild(plusShadow)
        container.addChild(plusLabel)
        container.addChild(buyButton)
        container.addChild(titleShadow)
        container.addChild(titleLabel)
        container.addChild(priceLabel)
        
        addChild(container)
        
        // Add buy action
        buyButton.action = confirmPurchase
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirmPurchase() {
        let container = SKSpriteNode(imageNamed: "confirmPurchaseBackground")
        container.setScale(1.0 / Constant.ScaleFactor)
        
        let confirmPurchaseNode = DropdownNode(container: container)
        
//        let purchaseText = "\(diceKey) Rewards Dice"
//        
//        let purchaseLabel = SKLabelNode(text: purchaseText.uppercased())
//        purchaseLabel.fontName = Constant.FontNameExtraBold
//        purchaseLabel.fontColor = UIColor.white
//        purchaseLabel.fontSize = 14
//        purchaseLabel.position = CGPoint(x: 0, y: 40)
//        
//        let purchaseLabelShadow = purchaseLabel.createLabelShadow()
        
        let starCoinNode = SKSpriteNode(imageNamed: "starCoin")
        starCoinNode.position = CGPoint(x: 0, y: 10)
        
        let countLabel = SKLabelNode(text: "x\(count)")
        countLabel.fontName = Constant.FontName
        countLabel.fontColor = UIColor.darkGray
        countLabel.fontSize = 14
        countLabel.horizontalAlignmentMode = .left
        countLabel.position = CGPoint(x: 20, y: -10)
        
        starCoinNode.addChild(countLabel)
        
        let priceTitleLabel = SKLabelNode(text: "PRICE:")
        priceTitleLabel.fontName = Constant.FontNameExtraBold
        priceTitleLabel.fontColor = UIColor.white
        priceTitleLabel.fontSize = 14
        priceTitleLabel.position = CGPoint(x: -30, y: -30)
        
        let priceTitleLabelShadow = priceTitleLabel.createLabelShadow()
        
        let priceLabel = SKLabelNode(text: price)
        priceLabel.fontName = Constant.FontNameCondensed
        priceLabel.fontColor = UIColor.darkGray
        priceLabel.fontSize = 14
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 30, y: 0)
        
        priceTitleLabel.addChild(priceLabel)
        
        let confirmButton = ButtonNode(defaultButtonImage: "confirmButton")
        confirmButton.position = CGPoint(x: -50, y: -80)
        confirmButton.action = {
            // DELETE: Add to GameData
//            GameData.addRewardsDiceCount(self.diceKey.rawValue, num: self.count)
//            GameData.subtractCoins(self.total)
//            GameData.save()
            
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateHUDAfterBuy"), object: self)
            
            confirmPurchaseNode.close()
        }
        
        let cancelButton = ButtonNode(defaultButtonImage: "cancelButton")
        cancelButton.position = CGPoint(x: 50, y: -80)
        cancelButton.action = confirmPurchaseNode.close
        
//        container.addChild(purchaseLabelShadow)
//        container.addChild(purchaseLabel)
        container.addChild(starCoinNode)
        container.addChild(priceTitleLabelShadow)
        container.addChild(priceTitleLabel)
        container.addChild(confirmButton)
        container.addChild(cancelButton)
        
        self.parent?.addChild(confirmPurchaseNode.createLayer())
    }
}

