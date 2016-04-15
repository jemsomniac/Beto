//
//  Board.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

let Columns = 3
let Rows = 2

class Board {
    private var squares = Array2D<Square>(columns: Columns, rows: Rows)
    private let squareSize: CGFloat = 92.0
    
    private let scene: BoardScene
    private let boardNode: SKSpriteNode
    private let playButton: ButtonNode
    private let clearButton: ButtonNode
    private let coinVaultButton: ButtonNode
    
    private let layer = SKNode()
    private var selectedSquares: [Square] = []
    
    var winningSquares = [Square]()
        
    init(scene: BoardScene) {
        self.scene = scene
        
        boardNode = SKSpriteNode(imageNamed: "board")
        boardNode.size = CGSize(width: 300, height: 280)
        boardNode.position = CGPoint(x: 0, y: (-ScreenSize.height + boardNode.size.height) / 2 + 60)
        
        // Play Button
        playButton = ButtonNode(defaultButtonImage: "playButton", activeButtonImage: "playButton_active")
        playButton.size = CGSize(width: 110, height: 40)
        playButton.position = CGPoint(x: (-boardNode.size.width + playButton.size.width) / 2 + Constant.Margin,
            y: (-boardNode.size.height + playButton.size.height) / 2 + Constant.Margin)
        
        // Clear Button
        clearButton = ButtonNode(defaultButtonImage: "clearButton", activeButtonImage: "clearButton_active")
        clearButton.size = CGSize(width: 110, height: 40)
        clearButton.position = CGPoint(x: (boardNode.size.width - clearButton.size.width) / 2 - Constant.Margin,
            y: (-boardNode.size.height + clearButton.size.height) / 2 + Constant.Margin)
        
        // Coin Vault Button
        coinVaultButton = ButtonNode(defaultButtonImage: "coin\(GameData.defaultBetValue)")
        // DELETE: Because of atlas. Not sure why it has to be this way
        coinVaultButton.defaultButton.size = CGSize(width: 40, height: 40)
        coinVaultButton.activeButton.size = CGSize(width: 40, height: 40)
        coinVaultButton.position = CGPoint(x: 0, y: (-boardNode.size.height + coinVaultButton.size.height) / 2 + Constant.Margin)
        
        // Squares creation
        var colors = [Color.Blue, Color.Red, Color.Green, Color.Yellow, Color.Cyan, Color.Purple]
        var index = 0
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = Square(color: colors[index], defaultButtonImage: colors[index].squareSpriteName, activeButtonImage: colors[index].squareSpriteName + "_active")
                // DELETE: Because of atlas. Not sure why it has to be this way
                square.defaultButton.size = CGSize(width: squareSize, height: squareSize)
                square.activeButton.size = CGSize(width: squareSize, height: squareSize)
                square.position = pointForColumn(column, row: row)
        
                squares[column, row] = square
                index+=1
            }
        }
    }
    
    func createBoardLayer() -> SKNode {
        // Add actions
        playButton.action = playButtonPressed
        clearButton.action = clearButtonPressed
        coinVaultButton.action = coinVaultButtonPressed
        
        // Add action to square and add each square to boardNode
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                
                square.placeBetHandler = handlePlaceBet
                boardNode.addChild(square)
            }
        }
        
        boardNode.addChild(playButton)
        boardNode.addChild(clearButton)
        boardNode.addChild(coinVaultButton)
        
        layer.addChild(boardNode)
        
        return layer
    }
    
    func handlePlaceBet(square: Square) {
        let coinsAvailable = GameData.coins - getWagers()
        
        if !selectedSquares.contains(square) && selectedSquares.count >= 3 {
            scene.runAction(Audio.lostSound)
            
            let testNode = SKLabelNode(text: "SELECT UP TO 3 COLORS!")
            testNode.fontSize = 24
            testNode.color = SKColor.blueColor()
            testNode.colorBlendFactor = 1
            testNode.fontName = "Futura-Medium"
            testNode.blendMode = SKBlendMode.Multiply
            testNode.colorBlendFactor = 0.6
            testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin)
            boardNode.addChild(testNode)
            
            let fade = SKAction.fadeOutWithDuration(1.0)
            testNode.runAction(fade)
            
            return
        }
        
        if GameData.defaultBetValue <= coinsAvailable  {
            if !selectedSquares.contains(square) {
                selectedSquares.append(square)
            }
            
            square.wager += GameData.defaultBetValue
            
            let coins = GameData.coins - getWagers()
            scene.gameHUD.coinsLabel.text = "\(coins)"
            scene.runAction(Audio.placeBetSound)
            
            square.label.hidden = false
            square.label.text = "\(square.wager)"
        }
        else {
            scene.runAction(Audio.lostSound)
            
            let testNode = SKLabelNode(text: "NOT ENOUGH COINS!")
            testNode.fontSize = 24
            testNode.color = SKColor.blueColor()
            testNode.colorBlendFactor = 1
            testNode.fontName = "Futura-Medium"
            testNode.blendMode = SKBlendMode.Multiply
            testNode.colorBlendFactor = 0.6
            testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin)
            boardNode.addChild(testNode)
            
            let fade = SKAction.fadeOutWithDuration(1.0)
            testNode.runAction(fade)
        }
    }
    
    func playButtonPressed() {
        if getWagers() > 0 {
            scene.presentGameScene()
            selectedSquares = []
        }
    }
    
    func getWiningSquares(row: Int, column: Int) {
        let square = squareAtColumn(column, row: row)
        winningSquares.append(square)
        print("\(square.color) - \(square.wager)")
    }
    
    func handleResults() {
        //Reselect , Add winning to total , udpate labels
        
        if winningSquares.last?.wager > 0 {
            // re-select winning squares
            if !selectedSquares.contains(winningSquares.last!) {
                print(selectedSquares.count)
                selectedSquares.append(winningSquares.last!)
                print("added winning selectedsquare")
                print(selectedSquares.count)
                
            }
            // add winnings
            GameData.coins += winningSquares.last!.wager
            scene.runAction(Audio.winSound)
            
            // Update labels
            let coins = GameData.coins - getWagers()
            scene.gameHUD.coinsLabel.text = "\(coins)"
            scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)" //TODO: Ask Jem if OK to delete?
        }
    
        if winningSquares.count == 3 {

            // Remove wagers from winning squares
            for row in 0..<Rows {
                for column in 0..<Columns {
                    let square = squareAtColumn(column, row: row)
                    
                    if square.wager > 0 && !winningSquares.contains(square) {
                        
                        GameData.coins -= square.wager
                        
                        scene.runAction(Audio.lostSound)
                        
                        let scaleAction = SKAction.scaleTo(0.0, duration: 0.3)
                        scaleAction.timingMode = .EaseOut
                        
                        square.label.runAction(scaleAction)
                        
                        square.label.hidden = true
                        let restore = SKAction.scaleTo(1.0, duration: 0.3)
                        square.label.runAction(restore)
                        
                        square.wager = 0
                    }
                }
            }
            
            // Check if there's a new highscore
            if GameData.coins > GameData.highscore {
                GameData.highscore = GameData.coins
                scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
                GameData.didUnlockCoin()
            }
            GameData.saveGameData()
            winningSquares = []
        }
    }
    
    func clearButtonPressed() {
        // Set wagers to 0
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                square.wager = 0
            }
        }
        
        // Clear selected squares
        selectedSquares = []
        
        // Hide labels
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                square.label.hidden = true
            }
        }
        
        scene.runAction(Audio.clearBetSound)
        let coins = GameData.coins - getWagers()
        scene.gameHUD.coinsLabel.text = "\(coins)"
    }

    func coinVaultButtonPressed() {
        let coinVault = CoinVault()
        coinVault.changeBetValueHandler = changeVaultButtonTexture
        
        let vaultLayer = coinVault.createVaultLayer()
        scene.addChild(vaultLayer)
    }
    
    func changeVaultButtonTexture() {
        coinVaultButton.changeTexture("coin\(GameData.defaultBetValue)")
    }
    
    func squareAtColumn(column: Int, row: Int) -> Square {
        assert(column >= 0 && column < Columns)
        assert(row >= 0 && row < Rows)
        
        return squares[column, row]!
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let squareMargin: CGFloat = 6
        let squareWithMargin = squareSize + squareMargin
        
        let offsetX = -squareWithMargin + (squareWithMargin * CGFloat(column))
        let offsetY = -squareMargin + (squareWithMargin * CGFloat(row))

        return CGPoint(x: offsetX, y: -Constant.Margin + offsetY)
    }
    
    func getWagers() -> Int {
        var total = 0
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                
                total += square.wager
            }
        }
        
        return total
    }
}