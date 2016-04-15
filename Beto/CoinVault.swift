//
//  CoinVault.swift
//  Beto
//
//  Created by Jem on 3/5/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class CoinVault {
    
    let rows = 2
    let columns = 4
    
    private let layer = SKNode()
    private var coins: Array2D<Coin>
    
    var background: SKSpriteNode
    var vault: SKSpriteNode
    var closeButton: ButtonNode
    
    var changeBetValueHandler: (() -> ())?
    
    init() {
        coins = Array2D<Coin>(columns: columns, rows: rows)
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        background.alpha = 0.0
        
        vault = SKSpriteNode(imageNamed: "coinVault")
        vault.size = CGSize(width: 304, height: 174)
        vault.position = CGPoint(x: 0, y: ScreenSize.height)
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        // DELETE: Change position to dynamic values
        closeButton.position = CGPoint(x: 140, y: 74)
        
        var index = 0
        
        for row in 0..<rows  {
            for column in 0..<columns {
                var unlocked = false
                
                if index <= GameData.unlockedCoins {
                    unlocked = true
                }
                
                let coinHolder = SKSpriteNode(imageNamed: "coinHolder")
                coinHolder.size = CGSize(width: 42, height: 42)
                coinHolder.position = pointForColumn(column, row: row)
                
                let coin = Coin(value: BetValues[index], unlocked: unlocked)
                // DELETE: Because of atlas. Not sure why it has to be this way
                coin.defaultButton.size = CGSize(width: 38, height: 39)
                coin.activeButton.size = CGSize(width: 38, height: 39)
                coin.position = CGPoint(x: 1, y: -1)
                coin.coinSelectedHandler = handleCoinSelected
                
                coins[column, row] = coin
                
                coinHolder.addChild(coin)
                vault.addChild(coinHolder)
                
                index+=1
            }
        }
    }

    func createVaultLayer() -> SKNode {
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        vault.runAction(actions)
    
        closeButton.action = close
        
        vault.addChild(closeButton)
        layer.addChild(background)
        layer.addChild(vault)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.height, duration: 0.4)
        let vaultActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        vault.runAction(vaultActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
    
    func handleCoinSelected(coin: Coin) {
        GameData.defaultBetValue = coin.value
        changeBetValueHandler!()
        close()
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let squareMargin: CGFloat = 10
        let squareWithMargin = 40 + squareMargin
        
        let offsetX = (-squareWithMargin * 1.5) + (squareWithMargin * CGFloat(column))
        let offsetY = (squareWithMargin / 2) - (squareWithMargin * CGFloat(row)) - 10
        
        return CGPoint(x: offsetX, y: offsetY)
        
    }
}