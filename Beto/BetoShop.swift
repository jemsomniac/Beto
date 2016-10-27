//
//  BetoShop.swift
//  Beto
//
//  Created by Jem on 9/28/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

enum ShopType {
    case RewardsDice
    case StarCoins
}

class BetoShop: DropdownNode {
    fileprivate let container: SKSpriteNode
    
    init(type: ShopType) {
        container = SKSpriteNode(imageNamed: "betoShopBackground")
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        // Custom scale for iPhone 4 (Screen size: 320 x 480)
        if UIScreen.main.bounds.height == 480 {
            container.setScale(0.93)
        }
        
        super.init(container: container)
            
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        closeButton.action = close
        closeButton.position = CGPoint(x: 140, y: 160)
        closeButton.name = "closeButton"
        
        container.addChild(closeButton)
                
        switch(type) {
        case .RewardsDice:
            displayBuyDiceNode()
        case .StarCoins:
            displayBuyStarCoinsNode()
        }
            
//        displayMenuNode()
    }
    
//    func displayMenuNode() {
//        removeChildNodes()
//
//        let rewardsDiceButton = ButtonNode(defaultButtonImage: "purchaseRewardsDice")
//        rewardsDiceButton.action = displayBuyDiceNode
//        rewardsDiceButton.position = CGPoint(x: 0, y: 60)
//        
//        let starCoinsButton = ButtonNode(defaultButtonImage: "purchaseStarCoins")
//        starCoinsButton.action = displayBuyStarCoinsNode
//        starCoinsButton.position = CGPoint(x: 0, y: -60)
//        
//        container.addChild(rewardsDiceButton)
//        container.addChild(starCoinsButton)
//    }
    
    func displayBuyDiceNode() {
        removeChildNodes()

        let buyGold = BuyDiceNode(diceKey: .Gold, price: 50000)
        buyGold.position = pointForIndex(0)
        
        let buyPlatinum = BuyDiceNode(diceKey: .Platinum, price: 100000)
        buyPlatinum.position = pointForIndex(1)
        
        let buyDiamond = BuyDiceNode(diceKey: .Diamond, price: 500000)
        buyDiamond.position = pointForIndex(2)
        
        let buyRuby = BuyDiceNode(diceKey: .Ruby, price: 1000000)
        buyRuby.position = pointForIndex(3)
        
//        let backButton = ButtonNode(defaultButtonImage: "backButton")
//        backButton.action = displayMenuNode
//        backButton.position = CGPoint(x: 0, y: -145)
        
        container.addChild(buyGold)
        container.addChild(buyPlatinum)
        container.addChild(buyDiamond)
        container.addChild(buyRuby)
//        container.addChild(backButton)
    }
    
    func displayBuyStarCoinsNode() {
        removeChildNodes()
        
        let basic = BuyStarCoinsNode(count: 25, bonusDice: [.Gold, .Diamond, .Platinum], price: "$1.99")
        basic.position = pointForIndex(0)
        
        let plus = BuyStarCoinsNode(count: 100, bonusDice: [.Diamond, .Platinum, .Ruby], price: "$6.99")
        plus.position = pointForIndex(1)
        
        let premium = BuyStarCoinsNode(count: 150, bonusDice: [.Diamond, .Platinum, .Ruby], price: "$9.99")
        premium.position = pointForIndex(2)
        
        let ultimate = BuyStarCoinsNode(count: 300, bonusDice: [.Ruby, .Ruby, .Ruby], price: "$17.99")
        ultimate.position = pointForIndex(3)
        
//        let backButton = ButtonNode(defaultButtonImage: "backButton")
//        backButton.action = displayMenuNode
//        backButton.position = CGPoint(x: 0, y: -145)
        
        let addFreeText = SKSpriteNode(imageNamed: "adFree")
        addFreeText.position = CGPoint(x: 0, y: -145)
        
        container.addChild(basic)
        container.addChild(plus)
        container.addChild(premium)
        container.addChild(ultimate)
//        container.addChild(backButton)
        container.addChild(addFreeText)
    }
    
    func removeChildNodes() {
        let children = container.children
    
        for child in children {
            if child.name != "closeButton" {
                child.removeFromParent()
            }
        }
    }
    
    func pointForIndex(_ index: Int) -> CGPoint {
        let offsetY = 90 - 60 * index
        
        return CGPoint(x: 0, y: offsetY)
    }
}
