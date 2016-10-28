//
//  BuyDiceNode.swift
//  Beto
//
//  Created by Jem on 9/28/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BuyDiceNode: SKNode {
    var count = 1
    var total: Int
    var diceKey: RewardsDiceKey
    var buyButton: ButtonNode
    var priceLabel: SKLabelNode
    var countLabel: SKLabelNode
    
    init(diceKey: RewardsDiceKey, price: Int) {
        self.diceKey = diceKey
        
        total = price * count
        
        // Buy button
        buyButton = ButtonNode(defaultButtonImage: "buyButton")
        buyButton.position = CGPoint(x: 80, y: 10)
        
        // Configure price
        let titleLabel = SKLabelNode(text: "PRICE:")
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 50, y: -20)
        
        let titleShadow = titleLabel.createLabelShadow()
        
        priceLabel = SKLabelNode(text: "\(total.formatStringFromNumber())")
        priceLabel.fontName = Constant.FontNameCondensed
        priceLabel.fontColor = UIColor.darkGray
        priceLabel.fontSize = 14
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 75, y: -20)
        
        // Configure count
        countLabel = SKLabelNode(text: "\(count)")
        countLabel.fontName = Constant.FontNameCondensed
        countLabel.fontSize = 14
        countLabel.horizontalAlignmentMode = .center
        countLabel.verticalAlignmentMode = .center
        
        super.init()
        
        let container = SKSpriteNode(imageNamed: "dropNodeCellBackground")
        container.size = CGSize(width: 276, height: 60)
        
        let imageName = "\(diceKey.rawValue.lowercased())Reward"
        
        let dice = SKSpriteNode(imageNamed: imageName)
        dice.position = CGPoint(x: -108, y: 0)
        
        // Configure buy count button
        let buyCount = SKSpriteNode(imageNamed: "buyCountBackground")
        buyCount.position = CGPoint(x: -38, y: 0)
        
        let addButton = ButtonNode(defaultButtonImage: "addButton")
        addButton.position = CGPoint(x: -25, y: 0)
        addButton.action = {
            if self.count < 999 {
                self.count += 1
                self.total = self.count * price
                self.updateLabels()
            }
        }
        
        let subtractButton = ButtonNode(defaultButtonImage: "subtractButton")
        subtractButton.position = CGPoint(x: 25, y: 0)
        subtractButton.action = {
            if self.count > 1 {
                self.count -= 1
                self.total = self.count * price
                self.updateLabels()
            }
        }

        buyCount.addChild(countLabel)
        buyCount.addChild(addButton)
        buyCount.addChild(subtractButton)
        
        container.addChild(dice)
        container.addChild(buyCount)
        container.addChild(buyButton)
        container.addChild(titleShadow)
        container.addChild(titleLabel)
        container.addChild(priceLabel)
        
        addChild(container)
        
        // Toggle button and price color (red if not enough coins)
        toggleBuy()
        
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
        
        let purchaseText = "\(diceKey) Rewards Dice"
        
        let purchaseLabel = SKLabelNode(text: purchaseText.uppercased())
        purchaseLabel.fontName = Constant.FontNameExtraBold
        purchaseLabel.fontColor = UIColor.white
        purchaseLabel.fontSize = 14
        purchaseLabel.position = CGPoint(x: 0, y: 40)
        
        let purchaseLabelShadow = purchaseLabel.createLabelShadow()
    
        let imageName = "\(diceKey.rawValue.lowercased())Reward"
        let dice = SKSpriteNode(imageNamed: imageName)
        dice.position = CGPoint(x: 0, y: 10)

        let countLabel = SKLabelNode(text: "x\(count)")
        countLabel.fontName = Constant.FontName
        countLabel.fontColor = UIColor.darkGray
        countLabel.fontSize = 14
        countLabel.horizontalAlignmentMode = .left
        countLabel.position = CGPoint(x: 20, y: -10)

        dice.addChild(countLabel)
        
        let priceTitleLabel = SKLabelNode(text: "PRICE:")
        priceTitleLabel.fontName = Constant.FontNameExtraBold
        priceTitleLabel.fontColor = UIColor.white
        priceTitleLabel.fontSize = 14
        priceTitleLabel.position = CGPoint(x: -30, y: -30)
    
        let priceTitleLabelShadow = priceTitleLabel.createLabelShadow()

        let price = SKLabelNode(text: "\(total.formatStringFromNumber())")
        price.fontName = Constant.FontNameCondensed
        price.fontColor = UIColor.darkGray
        price.fontSize = 14
        price.horizontalAlignmentMode = .left
        price.position = CGPoint(x: 30, y: 0)
        
        priceTitleLabel.addChild(price)
        
        let confirmButton = ButtonNode(defaultButtonImage: "confirmButton")
        confirmButton.position = CGPoint(x: -50, y: -80)
        confirmButton.action = {
            GameData.addRewardsDiceCount(self.diceKey.rawValue, num: self.count)
            GameData.subtractCoins(self.total)
            GameData.save()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateCoinsLabelAfterBuy"), object: self)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleBuyButtons"), object: self)

            confirmPurchaseNode.close()
        }
        
        let cancelButton = ButtonNode(defaultButtonImage: "cancelButton")
        cancelButton.position = CGPoint(x: 50, y: -80)
        cancelButton.action = confirmPurchaseNode.close
        
        container.addChild(purchaseLabelShadow)
        container.addChild(purchaseLabel)
        container.addChild(dice)
        container.addChild(priceTitleLabelShadow)
        container.addChild(priceTitleLabel)
        container.addChild(confirmButton)
        container.addChild(cancelButton)
        
        self.parent?.addChild(confirmPurchaseNode.createLayer())
    }
    
    func toggleBuy() {
        if total > GameData.coins {
            buyButton.isUserInteractionEnabled = false
            priceLabel.fontColor = UIColor.red
        } else {
            buyButton.isUserInteractionEnabled = true
            priceLabel.fontColor = UIColor.darkGray
        }
    }
    
    func updateLabels() {
        countLabel.text = "\(count)"
        priceLabel.text = "\(total.formatStringFromNumber())"
        
        toggleBuy()
    }
}
