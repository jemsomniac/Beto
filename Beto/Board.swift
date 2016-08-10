//
//  Board.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Board {
    private let squareSize: CGFloat = 92.0
    
    private let layer: SKNode
    private let scene: BoardScene
    private let boardNode: SKSpriteNode
    private let playButton: ButtonNode
    private let clearButton: ButtonNode
    private let replayButton: ButtonNode
    private let coinVaultButton: ButtonNode
    
    private var squares: [Square]
    private var winningSquares: [Square]
    private var previousBets: [(color: Color, wager: Int)]
    
    var colorsSelected = 0
    
    init(scene: BoardScene) {
        self.scene = scene
        
        squares = []
        winningSquares = []
        previousBets = []
        
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        boardNode = SKSpriteNode(imageNamed: GameData.theme.board)
        boardNode.size = CGSize(width: 300, height: 280)
        
        playButton = ButtonNode(defaultButtonImage: "playButton", activeButtonImage: "playButton_active")
        playButton.size = CGSize(width: 130, height: 40)
        
        clearButton = ButtonNode(defaultButtonImage: "clearButton", activeButtonImage: "clearButton_active")
        clearButton.size = CGSize(width: 130, height: 40)
        
        replayButton = ButtonNode(defaultButtonImage: "replayButton")
        replayButton.size = CGSize(width: 38, height: 39)
        
        coinVaultButton = ButtonNode(defaultButtonImage: "coin\(GameData.betDenomination)")
        coinVaultButton.size = CGSize(width: 38, height: 39)
        
        // Initialize the squares
        for color in Color.allValues {
            let square = Square(color: color)
            square.size = CGSize(width: squareSize, height: squareSize)
            
            squares.append(square)
        }
    }
    
    func createLayer() -> SKNode {
        // Assign actions
        playButton.action = playButtonPressed
        clearButton.action = clearButtonPressed
        replayButton.action = replayButtonPressed
        coinVaultButton.action = coinVaultButtonPressed
        
        var boardPosition = CGPoint(x: 0, y: -80)

        // Custom board position for iPhone 4
        if UIScreen.mainScreen().bounds.height == 480 {
            boardPosition = CGPoint(x: 0, y: -50)
        }
        
        // Designate positions
        boardNode.position = boardPosition
        playButton.position = CGPoint(x: (-boardNode.size.width + playButton.size.width) / 2 + Constant.Margin,
                                      y: (-boardNode.size.height + playButton.size.height) / 2 + Constant.Margin)
        clearButton.position = CGPoint(x: (boardNode.size.width - clearButton.size.width) / 2 - Constant.Margin,
                                       y: (-boardNode.size.height + clearButton.size.height) / 2 + Constant.Margin)
        coinVaultButton.position = CGPoint(x: (boardNode.size.width - coinVaultButton.size.width) / 2,
                                           y: (boardNode.size.height + coinVaultButton.size.height + Constant.Margin) / 2)
        replayButton.position = CGPoint(x: (-boardNode.size.width + replayButton.size.width) / 2,
                                        y: (boardNode.size.height + replayButton.size.height + Constant.Margin) / 2)
        
        // Add nodes to boardNode
        boardNode.addChild(playButton)
        boardNode.addChild(clearButton)
        boardNode.addChild(replayButton)
        boardNode.addChild(coinVaultButton)
        
        // Add action to square and add each square to boardNode
        for square in squares {
            square.placeBetHandler = handlePlaceBet
            square.position = pointForPosition(squares.indexOf(square)!)
            boardNode.addChild(square)
        }
        
        // Add boardNode to the layer node
        layer.addChild(boardNode)
        
        return layer
    }
    
    func handlePlaceBet(square: Square) {
        let coinsAvailable = GameData.coins - getWagers()
        
        if coinsAvailable == 0 {
            scene.runAction(Audio.lostSound)
            return
        }
        
        // Limit selected squares to 3 colors
        if !square.selected && colorsSelected == 3 {
            let testNode = SKLabelNode(text: "SELECT UP TO 3 COLORS")
            testNode.fontName = Constant.FontName
            
            if UIScreen.mainScreen().bounds.height == 480 {
                testNode.fontSize = 14
                testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin)
            } else {
                testNode.fontSize = 16
                testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin * 2)
            }
            
            boardNode.addChild(testNode)
            
            let fade = SKAction.fadeOutWithDuration(1.0)
            let actions = SKAction.sequence([fade, SKAction.removeFromParent()])
            
            testNode.runAction(actions)
            
            scene.runAction(Audio.lostSound)
            
            return
        }
        
        // Wager all remaining coins if less than betDenomination
        if GameData.betDenomination <= coinsAvailable  {
            square.wager += GameData.betDenomination
        } else {
            square.wager += coinsAvailable
        }
       
        // In order to safe guard from crashes, we don't subtract the coins
        // from the GameData until after we roll the cubes
        let coins = GameData.coins - getWagers()
        scene.gameHUD.updateCoinsLabel(coins)
        scene.runAction(Audio.placeBetSound)
            
        square.updateLabel()
            
        if !square.selected {
            square.label.hidden = false
            square.selected = true
            colorsSelected += 1
        }
    }
    
    func playButtonPressed() {
        if getWagers() > 0 {
            // Reset previousBets
            previousBets = []
            
            // Save bets for the replay button
            for square in squares {
                if square.selected {
                    previousBets.append((color: square.color, wager: square.wager))
                }
            }
            
            scene.presentGameScene()
        }
    }
    
    func replayButtonPressed() {
        clearButtonPressed()
        
        for previousBet in previousBets {
            if let index = squares.indexOf(squareWithColor(previousBet.color)) {
                squares[index].wager = previousBet.wager
                squares[index].label.hidden = false
                squares[index].updateLabel()
                squares[index].selected = true
                
                colorsSelected += 1
            }
        }
        
        // In order to safe guard from crashes, we don't subtract the coins
        // from the GameData until after we roll the cubes
        let coins = GameData.coins - getWagers()
        scene.gameHUD.updateCoinsLabel(coins)
    }
    
    func payout(winningColor: Color) -> Bool {
        var winningSquare: Square!
        var didWin = false
        
        // Keep track of winning squares
        for square in squares {
            if square.color == winningColor {
                winningSquare = square
                
                if !winningSquares.contains(winningSquare) {
                    winningSquares.append(winningSquare)
                }
                
                break
            }
        }
        
        // Add winnings
        if winningSquare.wager > 0 {
            GameData.addCoins(winningSquare.wager)

            // DELETE: Temp
            if GameData.doublePayout > 0 {
                GameData.addCoins(winningSquare.wager)
            }
            
            scene.runAction(Audio.winSound)
            
            didWin = true
            
            // Update labels
            scene.gameHUD.updateCoinsLabel(GameData.coins)
            scene.gameHUD.updateHighscoreLabel(GameData.highscore)
        }
        
        return didWin
    }
    
    func resolveWagers() {
        var highestWager = 0
        
        // Add winning wagers back to GameData.coins, clear the board
        for square in squares {
            if winningSquares.contains(square) {
                GameData.addCoins(square.wager)
            }
            
            if square.wager > highestWager {
                highestWager = square.wager
            }
            
            let scaleAction = SKAction.scaleTo(0.0, duration: 0.3)
            scaleAction.timingMode = .EaseOut
            square.label.runAction(scaleAction)
            square.label.hidden = true
            
            let restore = SKAction.scaleTo(1.0, duration: 0.3)
            square.label.runAction(restore)
            square.wager = 0
            square.selected = false
            
            // Update labels
            scene.gameHUD.updateCoinsLabel(GameData.coins)
            scene.gameHUD.updateHighscoreLabel(GameData.highscore)
        }
        
        // Check Achievement: HighestWager
        GameData.updateHighestWager(highestWager)
        
        // Reset winning squares
        winningSquares = []
    }
    
    func clearButtonPressed() {
        // reset each square
        for square in squares {
            square.wager = 0
            square.label.hidden = true
            square.selected = false
        }
        
        colorsSelected = 0
        
        scene.runAction(Audio.clearBetSound)
        scene.gameHUD.updateCoinsLabel(GameData.coins)
    }
    
    func coinVaultButtonPressed() {
        let coinVault = CoinVault()
        coinVault.changeDenominationHandler = {
            self.coinVaultButton.changeTexture("coin\(GameData.betDenomination)")
        }
        
        let vaultLayer = coinVault.createLayer()
        scene.addChild(vaultLayer)
    }
    
    func squareWithColor(color: Color) -> Square! {
        for square in squares {
            if square.color == color {
                return square
            }
        }
        
        // Return nil if square is not found. This code should never execute
        return nil
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
        
        let squareMargin: CGFloat = 6
        let squareWithMargin = squareSize + squareMargin
        
        let offsetX = -squareWithMargin + (squareWithMargin * CGFloat(column))
        let offsetY = -squareMargin + (squareWithMargin * CGFloat(row))
        
        return CGPoint(x: offsetX, y: -Constant.Margin + offsetY)
    }
    
    func getWagers() -> Int {
        var wagers = 0
        
        for square in squares {
            wagers += square.wager
        }
        
        return wagers
    }

    
    func toggleReplayButton() {
        var wagers = 0
        
        for previousBet in previousBets {
            wagers += previousBet.wager
        }
        
        let coinsAvailable = GameData.coins - wagers
        
        if previousBets.isEmpty || coinsAvailable < 0 {
            replayButton.hidden = true
        } else {
            replayButton.hidden = false
        }
    }
}