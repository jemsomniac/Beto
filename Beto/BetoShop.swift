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
        
        // Configure shop type
        switch(type) {
        case .RewardsDice:
            displayBuyDiceNode()
        case .StarCoins:
            displayBuyStarCoinsNode()
        }
    }
    
    func displayBuyDiceNode() {
        let buyGold = BuyDiceNode(diceKey: .Gold, price: 50000)
        buyGold.position = pointForIndex(0)
        
        let buyPlatinum = BuyDiceNode(diceKey: .Platinum, price: 100000)
        buyPlatinum.position = pointForIndex(1)
        
        let buyDiamond = BuyDiceNode(diceKey: .Diamond, price: 500000)
        buyDiamond.position = pointForIndex(2)
        
        let buyRuby = BuyDiceNode(diceKey: .Ruby, price: 1000000)
        buyRuby.position = pointForIndex(3)
        
        container.addChild(buyGold)
        container.addChild(buyPlatinum)
        container.addChild(buyDiamond)
        container.addChild(buyRuby)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleBuyButtons), name: NSNotification.Name(rawValue: "toggleBuyButtons"), object: nil)
    }
    
    func displayBuyStarCoinsNode() {
        GameData.unlockedAchievementHandler = showUnlockedAchievements
        
        // Initialize packages
        let basicPackage = Package(name: "Basic", starCoins: 25, bonusDice: [.Gold, .Platinum, .Diamond], price: "$1.99")
        let plusPackage = Package(name: "Plus", starCoins: 100, bonusDice: [.Platinum, .Diamond, .Ruby], price: "$6.99")
        let premiumPackage = Package(name: "Premium", starCoins: 150, bonusDice: [.Platinum, .Diamond, .Ruby], price: "$9.99")
        let ultimatePackage = Package(name: "Ultimate", starCoins: 300, bonusDice: [.Ruby, .Ruby, .Ruby], price: "$17.99")
        
        let basic = BuyStarCoinsNode(package: basicPackage)
        basic.position = pointForIndex(0)
        
        let plus = BuyStarCoinsNode(package: plusPackage)
        plus.position = pointForIndex(1)
        
        let premium = BuyStarCoinsNode(package: premiumPackage)
        premium.position = pointForIndex(2)
        
        let ultimate = BuyStarCoinsNode(package: ultimatePackage)
        ultimate.position = pointForIndex(3)
        
        let addFreeText = SKSpriteNode(imageNamed: "adFree")
        addFreeText.position = CGPoint(x: 0, y: -145)
        
        container.addChild(basic)
        container.addChild(plus)
        container.addChild(premium)
        container.addChild(ultimate)
        container.addChild(addFreeText)
    }
    
    fileprivate func showUnlockedAchievements(_ achievement: Achievement) {
        let unlocked = AchievementUnlocked(achievement: achievement)
        container.addChild(unlocked.createLayer())
        
        // DELETE: Test if this will cause an error if coming from the adButton
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateStarCoinsLabelAfterBuy"), object: self)
    }
    
    @objc fileprivate func toggleBuyButtons() {
        for child in container.children {
            if let node = child as? BuyDiceNode {
                node.toggleBuy()
            }
        }
    }
    
    func pointForIndex(_ index: Int) -> CGPoint {
        let offsetY = 90 - 60 * index
        
        return CGPoint(x: 0, y: offsetY)
    }
}
