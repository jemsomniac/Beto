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
    private let replayButton: ButtonNode
    private let coinVaultButton: ButtonNode
    
    private let layer = SKNode()
    private var selectedSquares: [Square] = []
    private var winningSquares: [Square] = []
    
    init(scene: BoardScene) {
        self.scene = scene
        
        boardNode = SKSpriteNode(imageNamed: "board")
        boardNode.size = CGSize(width: 300, height: 280)
        boardNode.position = CGPoint(x: 0, y: (-ScreenSize.height + boardNode.size.height) / 2 + 60)
        
        // Play Button
        playButton = ButtonNode(defaultButtonImage: "playButton", activeButtonImage: "playButton_active")
        playButton.size = CGSize(width: 130, height: 40)
        playButton.position = CGPoint(x: (-boardNode.size.width + playButton.size.width) / 2 + Constant.Margin,
                                      y: (-boardNode.size.height + playButton.size.height) / 2 + Constant.Margin)
        
        // Clear Button
        clearButton = ButtonNode(defaultButtonImage: "clearButton", activeButtonImage: "clearButton_active")
        clearButton.size = CGSize(width: 130, height: 40)
        clearButton.position = CGPoint(x: (boardNode.size.width - clearButton.size.width) / 2 - Constant.Margin,
                                       y: (-boardNode.size.height + clearButton.size.height) / 2 + Constant.Margin)
        
        // Replay Button
        replayButton = ButtonNode(defaultButtonImage: "replayButton")
        replayButton.size = CGSize(width: 38, height: 39)
        replayButton.position = CGPoint(x: (-boardNode.size.width + replayButton.size.width) / 2,
                                        y: (boardNode.size.height + replayButton.size.height + Constant.Margin) / 2)
        
        // Coin Vault Button
        coinVaultButton = ButtonNode(defaultButtonImage: "coin\(GameData.defaultBetValue)")
        // DELETE: Because of atlas. Not sure why it has to be this way
        coinVaultButton.defaultButton.size = CGSize(width: 38, height: 39)
        coinVaultButton.activeButton.size = CGSize(width: 38, height: 39)
        coinVaultButton.position = CGPoint(x: (boardNode.size.width - coinVaultButton.size.width) / 2,
                                           y: (boardNode.size.height + coinVaultButton.size.height + Constant.Margin) / 2)
        
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
                index += 1
            }
        }
    }
    
    func createBoardLayer() -> SKNode {
        // Add actions
        playButton.action = playButtonPressed
        clearButton.action = clearButtonPressed
        replayButton.action = replayButtonPressed
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
        boardNode.addChild(replayButton)
        boardNode.addChild(coinVaultButton)
        
        layer.addChild(boardNode)
        
        return layer
    }
    
    func handlePlaceBet(square: Square) {
        let coinsAvailable = GameData.coins - getWagers()
        
        // Limit selected squares to 3 colors
        if !selectedSquares.contains(square) && selectedSquares.count >= 3 {
            scene.runAction(Audio.lostSound)
            
            let testNode = SKLabelNode(text: "SELECT UP TO 3 COLORS!")
            testNode.fontSize = 18
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
        
        // Check if there are coins available to wager
        if GameData.defaultBetValue <= coinsAvailable  {
            if !selectedSquares.contains(square) {
                selectedSquares.append(square)
            }
            
            square.wager += GameData.defaultBetValue
            
            // In order to safe guard from crashes, we don't subtract the coins
            // from the GameData until after we roll the cubes
            let coins = GameData.coins - getWagers()
            scene.gameHUD.coinsLabel.text = "\(coins)"
            scene.runAction(Audio.placeBetSound)
            
            square.label.hidden = false
            square.label.text = "\(square.wager)"
        } else {
            scene.runAction(Audio.lostSound)
            
            let testNode = SKLabelNode(text: "NOT ENOUGH COINS!")
            testNode.fontSize = 18
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
    
    func replayButtonPressed() {
        // re-select winning squares
        //        if !selectedSquares.contains(winningSquares.last!) {
        //            print(selectedSquares.count)
        //            selectedSquares.append(winningSquares.last!)
        //            print("added winning selectedsquare")
        //            print(selectedSquares.count)
        //
        //        }
        
        //  selectedSquares = []
        
        // NEED TO IMPLEMENT THIS.
    }
    
    func payout(winningColor: Color) {
        var winningSquare: Square!
        
        outerloop: for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                
                if square.color == winningColor {
                    winningSquare = square
                    
                    if !winningSquares.contains(winningSquare) {
                        winningSquares.append(winningSquare)
                    }
                    
                    break outerloop
                }
            }
        }
        
        // Add winnings
        if winningSquare.wager > 0 {
            GameData.coins += winningSquare.wager
            scene.runAction(Audio.winSound)
            
            // Update coinslabel
            scene.gameHUD.coinsLabel.text = "\(GameData.coins)"
            
            // Check and update if there's a new highscore
            if GameData.coins > GameData.highscore {
                GameData.highscore = GameData.coins
                scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
                GameData.didUnlockCoin()
            }
        }
    }
    
    func resolveWagers() {
        // Add winning wagers back to Game Data, clear the board
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squareAtColumn(column, row: row)
                
                if winningSquares.contains(square) {
                    GameData.coins += square.wager
                }
                
                let scaleAction = SKAction.scaleTo(0.0, duration: 0.3)
                scaleAction.timingMode = .EaseOut
                square.label.runAction(scaleAction)
                square.label.hidden = true
                
                let restore = SKAction.scaleTo(1.0, duration: 0.3)
                square.label.runAction(restore)
                square.wager = 0
                
                // Update coinslabel
                scene.gameHUD.coinsLabel.text = "\(GameData.coins)"
                
                // Check and update if there's a new highscore
                if GameData.coins > GameData.highscore {
                    GameData.highscore = GameData.coins
                    scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
                    GameData.didUnlockCoin()
                }
            }
        }
        
        GameData.saveGameData()
        winningSquares = []
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
        
        // DELETE: Check this code. Dont need getWagers i think
        let coins = GameData.coins - getWagers()
        scene.gameHUD.coinsLabel.text = "\(coins)"
    }
    
    func coinVaultButtonPressed() {
        let coinVault = CoinVault()
        coinVault.changeBetValueHandler = { self.coinVaultButton.changeTexture("coin\(GameData.defaultBetValue)") }
        
        let vaultLayer = coinVault.createVaultLayer()
        scene.addChild(vaultLayer)
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