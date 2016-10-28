//
//  BoardScene.swift
//  Beto
//
//  Created by Jem on 4/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene {
    fileprivate let layer: SKNode
    
    // GameHUD
    fileprivate let gameHUD: SKSpriteNode
    fileprivate let menuButton: ButtonNode
    fileprivate let highscoreButton: ButtonNode
    fileprivate let highscoreLabel: SKLabelNode
    fileprivate let coinsButton: ButtonNode
    fileprivate let coinsLabel: SKLabelNode
    
    // Board
    fileprivate let board: SKSpriteNode
    fileprivate let playButton: ButtonNode
    fileprivate let clearReplayButton: ButtonNode
    fileprivate let powerUpButton: ButtonNode
    fileprivate let deactivatePowerUpSprite: SKSpriteNode
    fileprivate let coinVaultButton: ButtonNode
    fileprivate let diceVaultButton: ButtonNode
    fileprivate let shopButton: ButtonNode

    // Squares
    fileprivate let squareSize: CGFloat = 92.0
    fileprivate(set) var selectedColors: [Color]
    fileprivate var squares: [Square]
    fileprivate var winningSquares: [Square]
    fileprivate var previousBets: [(color: Color, wager: Int)]
    
    fileprivate var unlockedCoins: [DropdownNode]
    fileprivate var unlockedAchievements: [DropdownNode]
    fileprivate var rewardTriggered = false
    fileprivate var rewardBoostActivated = false
    fileprivate var diceType: DiceType = .default
    
    fileprivate(set) var activePowerUp = ""
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        let themes = ThemeManager()
        let theme = themes.getTheme(GameData.currentThemeName)
        
        
        /***** Initialize Variables *****/
        selectedColors = []
        squares = []
        winningSquares = []
        previousBets = []
        unlockedCoins = []
        unlockedAchievements = []
        
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        // NOTE: setScale also affects ScreenSize.Height. Need to adjust accordingly
        
        /***** Initialize GameHUD *****/
        gameHUD = SKSpriteNode(imageNamed: "headerBackground")
        gameHUD.size = CGSize(width: 320, height: 38)
        gameHUD.position = CGPoint(x: 0, y: (ScreenSize.Height / Constant.ScaleFactor - gameHUD.size.height) / 2)

        menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        menuButton.position = CGPoint(x: (-gameHUD.size.width + menuButton.size.width + Constant.Margin) / 2 , y: 0)
        
        coinsButton = ButtonNode(defaultButtonImage: "coinsButton")
        coinsButton.size = CGSize(width: 100, height: 25)
        coinsButton.position = CGPoint(x: (gameHUD.size.width - coinsButton.size.width) / 2 - Constant.Margin, y: 0)
        
        coinsLabel = SKLabelNode()
        coinsLabel.fontName = Constant.FontNameCondensed
        coinsLabel.fontSize = 14
        coinsLabel.horizontalAlignmentMode = .center
        coinsLabel.verticalAlignmentMode = .top
        coinsLabel.position = CGPoint(x: 0, y: 7)
        
        highscoreButton = ButtonNode(defaultButtonImage: "highscoreButton")
        highscoreButton.size = CGSize(width: 100, height: 25)
        highscoreButton.position = CGPoint(x: coinsButton.position.x - (highscoreButton.size.width + Constant.Margin), y: 0)
        
        highscoreLabel = SKLabelNode()
        highscoreLabel.fontName = Constant.FontNameCondensed
        highscoreLabel.fontSize = 14
        highscoreLabel.horizontalAlignmentMode = .center
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(x: 0, y: 7)
        
        /***** Initialize Board *****/
        board = SKSpriteNode(imageNamed: theme.board)
        board.size = CGSize(width: 300, height: 280)
        board.position = CGPoint(x: 0, y: (-ScreenSize.Height / Constant.ScaleFactor + board.size.height) / 2 + 52) // AdMob Height: 50
        
        playButton = ButtonNode(defaultButtonImage: "playButton", activeButtonImage: "playButton_active")
        playButton.size = CGSize(width: 130, height: 40)
        playButton.position = CGPoint(x: (-board.size.width + playButton.size.width) / 2 + Constant.Margin,
                                      y: (-board.size.height + playButton.size.height) / 2 + Constant.Margin)
        
        clearReplayButton = ButtonNode(defaultButtonImage: "clearButton", activeButtonImage: "clearButton_active")
        clearReplayButton.name = "clearButton"
        clearReplayButton.size = CGSize(width: 130, height: 40)
        clearReplayButton.position = CGPoint(x: (board.size.width - clearReplayButton.size.width) / 2 - Constant.Margin,
                                             y: (-board.size.height + clearReplayButton.size.height) / 2 + Constant.Margin)
        
        // Initialize the squares
        for color in Color.allValues {
            let square = Square(color: color)
            square.size = CGSize(width: squareSize, height: squareSize)
            
            squares.append(square)
        }
        
        /***** Initialize Misc. Buttons *****/
        powerUpButton = ButtonNode(defaultButtonImage: "powerUpButton")
        powerUpButton.size = CGSize(width: 38, height: 39)
        powerUpButton.position = CGPoint(x: (-board.size.width + powerUpButton.size.width) / 2,
                                         y: board.position.y + (board.size.height + powerUpButton.size.height + Constant.Margin) / 2)
        
        coinVaultButton = ButtonNode(defaultButtonImage: "coin\(GameData.betDenomination)")
        coinVaultButton.size = CGSize(width: 38, height: 39)
        coinVaultButton.position = CGPoint(x: (board.size.width - coinVaultButton.size.width) / 2,
                                           y: board.position.y + (board.size.height + powerUpButton.size.height + Constant.Margin) / 2)
  
        diceVaultButton = ButtonNode(defaultButtonImage: "bronzeReward")
        diceVaultButton.size = CGSize(width: 31, height: 36)
        diceVaultButton.position = CGPoint(x: (board.size.width - diceVaultButton.size.width) / 2,
                                           y: gameHUD.position.y - (gameHUD.size.height + diceVaultButton.size.height + Constant.Margin) / 2)
        diceVaultButton.addWobbleAnimation()
        
        shopButton = ButtonNode(defaultButtonImage: "shopButton")
        shopButton.position = CGPoint(x: (board.size.width - shopButton.size.width) / 2,
                                      y: gameHUD.position.y - (gameHUD.size.height + shopButton.size.height + Constant.Margin) / 2)
        
        deactivatePowerUpSprite = SKSpriteNode(imageNamed: "deactivateButton")
        deactivatePowerUpSprite.size = CGSize(width: 18, height: 19)
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameData.unlockedCoinHandler = showUnlockedCoin
        GameData.unlockedAchievementHandler = showUnlockedAchievement
        
        // Set button actions
        menuButton.action = presentMenuScene
//        coinsButton.action = displayShop // DELETE: Test
        highscoreButton.action = displayAchievements
        
        playButton.action = playButtonPressed
        clearReplayButton.action = clearButtonPressed
        powerUpButton.action = powerUpButtonPressed
        coinVaultButton.action = coinVaultButtonPressed
        diceVaultButton.action = diceVaultButtonPressed
        shopButton.action = displayShop
        
        // Set text for labels
        updateCoinsLabel(GameData.coins)
        updateHighscoreLabel(GameData.highscore)

        // Add labels to corresponding nodes
        coinsButton.addChild(coinsLabel)
        highscoreButton.addChild(highscoreLabel)
        
        // Add nodes to gameHUD
        gameHUD.addChild(menuButton)
        gameHUD.addChild(highscoreButton)
        gameHUD.addChild(coinsButton)
        
        // Add nodes to board
        board.addChild(playButton)
        board.addChild(clearReplayButton)
        
        // Add action to square and add each square to board
        for square in squares {
            square.position = pointForPosition(squares.index(of: square)!)
            square.placeBetHandler = handlePlaceBet
            
            board.addChild(square)
        }
        
        layer.addChild(gameHUD)
        layer.addChild(board)
        layer.addChild(powerUpButton)
        layer.addChild(coinVaultButton)
        layer.addChild(diceVaultButton)
        layer.addChild(shopButton)
        
        // Initialize background
        let background = SKSpriteNode(imageNamed: theme.background)
        background.size = self.frame.size
        
        if !Audio.musicMuted {
            run(SKAction.wait(forDuration: 0.5), completion: {
                self.addChild(Audio.backgroundMusic)
            })
        }
        
        // Add background and main layer to the scene
        addChild(background)
        addChild(layer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDiceVaultButton), name: NSNotification.Name(rawValue: "toggleDiceVaultButton"), object: nil)
        
        // Toggle visibility of the diceVaultButton
        toggleDiceVaultButton()
        
        // Show Golden Ticket if player has 0 coins
        showGoldenTicket()
    }
    
    func toggleDiceVaultButton() {
        var isHidden = true
        
        for key in RewardsDiceKey.allValues.reversed() {
            let count = GameData.getRewardsDiceCount(key.rawValue)
            
            if count > 0 {
                let texture = key.rawValue.lowercased() + "Reward"
                diceVaultButton.changeTexture(texture)
                
                isHidden = false
                break
            }
        }
        
        diceVaultButton.isHidden = isHidden
        shopButton.isHidden = !isHidden
    }
    
    /***** GameHUD Functions *****/
    func updateCoinsLabel(_ coins: Int) {
        coinsLabel.text = coins.formatStringFromNumberShortenMillion()
    }
    
    func updateHighscoreLabel(_ highscore: Int) {
        highscoreLabel.text = highscore.formatStringFromNumberShortenMillion()
    }
    
    fileprivate func displayAchievements() {
        let achievements = AchievementsListNode()
        let layer = achievements.createLayer()
        
        addChild(layer)
    }
    
    fileprivate func displayShop() {        
        let shop = BetoShop(type: .RewardsDice)
        addChild(shop.createLayer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoinsLabelAfterBuy), name: NSNotification.Name(rawValue: "updateCoinsLabelAfterBuy"), object: nil)
    }
    
    func updateCoinsLabelAfterBuy() {
        coinsLabel.text = GameData.coins.formatStringFromNumberShortenMillion()
    }
    
    /***** Board Functions *****/
    fileprivate func pointForPosition(_ position: Int) -> CGPoint {
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
    
    fileprivate func handlePlaceBet(_ square: Square) {
        let coinsAvailable = GameData.coins - getWagers()
        
        if coinsAvailable == 0 {
            run(Audio.errorSound)
            return
        }
        
        // Limit selected squares to 3 colors
        if !square.selected && selectedColors.count == 3 {
            let colorLimitNode = SKLabelNode(text: "SELECT UP TO 3 COLORS")
            colorLimitNode.fontName = Constant.FontName
            colorLimitNode.fontSize = 16
            colorLimitNode.position = CGPoint(x: 0, y: board.position.y + 50)
    
            layer.addChild(colorLimitNode)
            
            let fade = SKAction.fadeOut(withDuration: 1.0)
            let actions = SKAction.sequence([fade, SKAction.removeFromParent()])
            
            colorLimitNode.run(actions)
            
            run(Audio.errorSound)
            
            return
        }
        
        // Wager all remaining coins if less than betDenomination
        if GameData.betDenomination <= coinsAvailable  {
            square.wager += GameData.betDenomination
        } else {
            square.wager += coinsAvailable
        }
        
        // In order to safe guard from crashes, we don't subtract the coins
        // from the GameData until after we roll the dice
        let coins = GameData.coins - getWagers()
        updateCoinsLabel(coins)
        run(Audio.placeBetSound)
        
        square.updateLabel()
        
        if !square.selected {
            square.label.isHidden = false
            square.selected = true
            
            selectedColors.append(square.color)
        }
        
        // Hard toggle to clearButton
        if clearReplayButton.name == "replayButton" {
            clearReplayButton.name = "clearButton"
            clearReplayButton.changeTexture("clearButton", activeTexture: "clearButton_active")
            clearReplayButton.action = clearButtonPressed
        }
    }
        
    fileprivate func playButtonPressed() {
        if getWagers() > 0 {
            // Reset previousBets
            previousBets = []
            
            // Save bets for the replay button
            for square in squares {
                if square.selected {
                    previousBets.append((color: square.color, wager: square.wager))
                }
            }
            
            presentGameScene()
        }
    }
    
    fileprivate func replayButtonPressed() {
        clearButtonPressed()
        
        for previousBet in previousBets {
            if let index = squares.index(of: squareWithColor(previousBet.color)) {
                squares[index].wager = previousBet.wager
                squares[index].label.isHidden = false
                squares[index].updateLabel()
                squares[index].selected = true
                
                selectedColors.append(squares[index].color)
            }
        }
        
        // In order to safe guard from crashes, we don't subtract the coins
        // from the GameData until after we roll the dice
        let coins = GameData.coins - getWagers()
        updateCoinsLabel(coins)
        
        clearReplayButton.name = "clearButton"
        clearReplayButton.changeTexture("clearButton", activeTexture: "clearButton_active")
        clearReplayButton.action = clearButtonPressed
    }
    
    fileprivate func clearButtonPressed() {
        // reset each square
        for square in squares {
            square.wager = 0
            square.label.isHidden = true
            square.selected = false
        }
        
        resetSquaresSelectedCount()

        if clearReplayButton.name == "replayButton" {
            run(Audio.placeBetSound)
        } else {
            run(Audio.clearBetSound)
        }
        
        updateCoinsLabel(GameData.coins)
        
        toggleReplayButton()
    }
    
    func toggleReplayButton() {
        var wagers = 0
        
        for previousBet in previousBets {
            wagers += previousBet.wager
        }
        
        let coinsAvailable = GameData.coins - wagers
        
        if !previousBets.isEmpty && coinsAvailable >= 0 {
            clearReplayButton.name = "replayButton"
            clearReplayButton.changeTexture("replayButton", activeTexture: "replayButton_active")
            clearReplayButton.action = replayButtonPressed
        }
    }
    
    /***** Misc. Button Functions *****/
    fileprivate func powerUpButtonPressed() {
        let powerUpVault = PowerUpVault(activePowerUp: activePowerUp)
        powerUpVault.activatePowerUpHandler = activatePowerUp
        
        addChild(powerUpVault.createLayer())
    }
    
    fileprivate func activatePowerUp(_ powerUp: PowerUp) {
        deactivatePowerUpButtonPressed()
        
        let button = ButtonNode(defaultButtonImage: powerUp.name!)
        button.action = deactivatePowerUpButtonPressed
        button.position = CGPoint(x: (-board.size.width + button.size.width) / 2,
                                  y: gameHUD.position.y - (gameHUD.size.height + diceVaultButton.size.height + Constant.Margin) / 2)

        deactivatePowerUpSprite.position = CGPoint(x: 12, y: -16)
        
        button.addChild(deactivatePowerUpSprite)
        layer.addChild(button)
        
        activePowerUp = powerUp.name!
    }
    
    func deactivatePowerUpButtonPressed() {
        deactivatePowerUpSprite.parent?.removeFromParent()
        deactivatePowerUpSprite.removeFromParent()
        
        activePowerUp = ""
    }
    
    fileprivate func coinVaultButtonPressed() {
        let coinVault = CoinVault()
        coinVault.changeDenominationHandler = {
            self.coinVaultButton.changeTexture("coin\(GameData.betDenomination)")
        }
        
        addChild(coinVault.createLayer())
    }
    
    fileprivate func diceVaultButtonPressed() {
        let rewardsDiceVault = RewardsDiceVault()
        rewardsDiceVault.openRewardsDiceHandler = openRewardsDice
        
        addChild(rewardsDiceVault.createLayer())
        
        // DELETE: Test
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoinsLabelAfterBuy), name: NSNotification.Name(rawValue: "updateCoinsLabelAfterBuy"), object: nil)
    }
    
    fileprivate func openRewardsDice(_ dice: RewardsDice) {
        let openRewards = OpenRewardsDice(diceKey: dice.key)
        addChild(openRewards.createLayer())        
    }
    
    /***** Gameplay Functions *****/    
    func resolvePayout(_ square: Square) {
        if !winningSquares.contains(square) {
            winningSquares.append(square)
        }
        
        // Add winnings
        if square.wager > 0 {
            let winnings = calculateWinnings(square)
            
            GameData.addCoins(winnings)
        
            run(Audio.winSound)
            
            // Update labels
            updateCoinsLabel(GameData.coins)
            updateHighscoreLabel(GameData.highscore)
        }
    }
    
    func calculateWinnings(_ square: Square) -> Int {
        var winnings = square.wager
        
        if activePowerUp == "" {
            // Skip if no payout powerup is active
        } else if activePowerUp == PowerUpKey.doublePayout.rawValue {
            winnings *= 2
        } else if activePowerUp == PowerUpKey.triplePayout.rawValue {
            winnings *= 3
        }
        
        return winnings
    }
    
    func didPayout(_ square: Square) -> Bool {
        if square.wager > 0 {
            return true
        } else {
            return false
        }
    }
    
    func resolveWagers(_ didWin: Bool) {
        var highestWager = 0
        
        // Add winning wagers back to GameData.coins, clear the board
        for square in squares {
            // PowerUp: Lifeline - Return half the wagers on a complete lost
            if !didWin && activePowerUp == PowerUpKey.lifeline.rawValue {
                GameData.addCoins(square.wager/2)
            }
            
            if winningSquares.contains(square) {
                GameData.addCoins(square.wager)
            }
            
            if square.wager > highestWager {
                highestWager = square.wager
            }
            
            let scaleAction = SKAction.scale(to: 0.0, duration: 0.3)
            scaleAction.timingMode = .easeOut
            square.label.run(scaleAction)
            square.label.isHidden = true
            
            let restore = SKAction.scale(to: 1.0, duration: 0.3)
            square.label.run(restore)
            square.wager = 0
            square.selected = false
            
            // Update labels
            updateCoinsLabel(GameData.coins)
            updateHighscoreLabel(GameData.highscore)
        }
        
        // Check Achievement: HighestWager
        GameData.updateHighestWager(highestWager)
        
        // Reset winning squares
        winningSquares = []
    }
    
    func getWagers() -> Int {
        var wagers = 0
        
        for square in squares {
            wagers += square.wager
        }
        
        return wagers
    }
    
    func squareWithColor(_ color: Color) -> Square! {
        for square in squares {
            if square.color == color {
                return square
            }
        }
        
        // Return nil if square is not found. This code should never execute
        return nil
    }
    
    func resetSquaresSelectedCount() {
        selectedColors = []
    }
    
    /***** Dropdown Functions *****/
    fileprivate func showUnlockedAchievement(_ achievement: Achievement) {
        let unlocked = AchievementUnlocked(achievement: achievement)
        unlockedAchievements.append(unlocked)
    }
    
    fileprivate func showUnlockedCoin() {
        let container = SKSpriteNode(imageNamed: "rewardUnlocked")
        container.size = CGSize(width: 304, height: 225)
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        let details = SKNode()
        
        let titleLabel = SKLabelNode(text: "COIN UNLOCKED")
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 0, y: 50)
        
        let titleShadow = titleLabel.createLabelShadow()
        
        let descriptionLabel = SKLabelNode(text: "Now available in the Coin Vault")
        descriptionLabel.fontName = Constant.FontName
        descriptionLabel.fontColor = UIColor.darkGray
        descriptionLabel.fontSize = 10
        descriptionLabel.position = CGPoint(x: 0, y: 35)
        
        let coin = SKSpriteNode(imageNamed: "coin\(Constant.Denominations[GameData.coinsUnlocked])")
        coin.size = CGSize(width: 38, height: 39)
        coin.position = CGPoint(x: 0, y: 10)
        
        // Add progress bar
        let progressBar = SKSpriteNode(imageNamed: "progressBar")
        progressBar.size = CGSize(width: 120, height: 6)
        progressBar.position = CGPoint(x: 0, y: -20)
        
        var progress = 1.0
        
        // Don't show label and calculate progress on last coin
        if GameData.coinsUnlocked != 7 {
            let nextCoinLabel = SKLabelNode(text: "Next Coin unlocks at \(Constant.CoinUnlockedAt[GameData.coinsUnlocked].formatStringFromNumberShortenMillion()) coins")
            nextCoinLabel.fontName = Constant.FontName
            nextCoinLabel.fontColor = UIColor.darkGray
            nextCoinLabel.fontSize = 10
            nextCoinLabel.position = CGPoint(x: 0, y: -40)
            
            details.addChild(nextCoinLabel)
            
            progress = Double(GameData.highscore) / Double(Constant.CoinUnlockedAt[GameData.coinsUnlocked])
            
            if progress > 1.0 {
                progress = 1.0
            }
        }
        
        let width = 120 * progress
        let offsetX = (width - 119.5) / 2
        
        let currentProgress = SKSpriteNode(imageNamed: "currentProgress")
        currentProgress.size = CGSize(width: width, height: 6)
        currentProgress.position = CGPoint(x: offsetX, y: 0)
        
        // Claim button
        let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
        claimButton.size = CGSize(width: 110, height: 40)
        claimButton.position = CGPoint(x: 0, y: -80)
        
        // Add nodes
        details.addChild(titleShadow)
        details.addChild(titleLabel)
        details.addChild(descriptionLabel)
        details.addChild(coin)
        
        progressBar.addChild(currentProgress)
        details.addChild(progressBar)
        
        container.addChild(details)
        container.addChild(claimButton)
        
        let coinUnlocked = DropdownNode(container: container)
        claimButton.action = coinUnlocked.close
        
        unlockedCoins.append(coinUnlocked)
        
//        addChild(coinUnlocked.createLayer())
    }
    
    func resolveRandomReward() {
        let rand = Int(arc4random_uniform(100)) + 1
    
        var rewardChance = GameData.rewardChance
        
        if activePowerUp == PowerUpKey.rewardBoost.rawValue {
            rewardChance *= 2
            rewardBoostActivated = true
        } else {
            rewardBoostActivated = false
        }
        
        if rand <= rewardChance {
            rewardTriggered = true
        } else {
            rewardTriggered = false
            
            // Increment Unlucky achievement
            GameData.incrementAchievement(.Unlucky)
        }
    }
    
    func showGoldenTicket() {
        if GameData.coins == 0 {
            let container = SKSpriteNode(imageNamed: "goldenTicketBackground")
            container.size = CGSize(width: 304, height: 267)
            container.position = CGPoint(x: 0, y: ScreenSize.Height)
            
            let rand = Int(arc4random_uniform(5))
            let flavorText = ["WHO DOESN'T LOVE FREE STUFF",
                              "HEY, LOOK WHAT I FOUND",
                              "BETTER LUCK THIS TIME",
                              "OUCH! CONSOLATION PRIZE?",
                              "YOU'LL PAY ME BACK, RIGHT?"]
            
            let titleLabel = SKLabelNode(text: flavorText[rand])
            titleLabel.fontName = Constant.FontNameExtraBold
            titleLabel.fontColor = UIColor.white
            titleLabel.fontSize = 14
            titleLabel.position = CGPoint(x: 0, y: 65)
            
            let titleShadow = titleLabel.createLabelShadow()
            
            container.addChild(titleShadow)
            container.addChild(titleLabel)
            
            let ticket = SKSpriteNode(imageNamed: "goldenTicket")
            container.addChild(ticket)
            
            // Claim button
            let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
            claimButton.size = CGSize(width: 110, height: 40)
            claimButton.position = CGPoint(x: 0, y: -100)
            
            // Add nodes
            container.addChild(claimButton)
            
            let goldenTicket = DropdownNode(container: container)
            
            claimButton.action = {
                goldenTicket.close()
                
                // Update labels
                self.updateCoinsLabel(GameData.coins)
                self.updateHighscoreLabel(GameData.highscore)
            }
            
            addChild(goldenTicket.createLayer())
            
            // Add coins in background
            GameData.addCoins(100)
            GameData.save()
        }
    }
    
    func showUnlockedNodes() {
        // Check for Random Reward
        if rewardTriggered {
            let rewardsDice: RewardsDice
            
            let rand = Int(arc4random_uniform(100)) + 1
            
            if rewardBoostActivated {
                // Chance: Bronze (50%), Silver (25%), Gold (15%), Platinum (5%), Diamond (4%), Ruby (1%)
                if rand <= 50 {
                    rewardsDice = RewardsDice(key: .Bronze, count: -99)
                } else if rand <= 75 {
                    rewardsDice = RewardsDice(key: .Silver, count: -99)
                } else if rand <= 90 {
                    rewardsDice = RewardsDice(key: .Gold, count: -99)
                } else if rand <= 95{
                    rewardsDice = RewardsDice(key: .Platinum, count: -99)
                } else if rand <= 99 {
                    rewardsDice = RewardsDice(key: .Diamond, count: -99)
                } else {
                    rewardsDice = RewardsDice(key: .Ruby, count: -99)
                }
            } else {
                // Chance: Bronze (70%), Silver (15%), Gold (9%), Platinum (3%), Diamond (2%), Ruby (1%)
                if rand <= 70 {
                    rewardsDice = RewardsDice(key: .Bronze, count: -99)
                } else if rand <= 85 {
                    rewardsDice = RewardsDice(key: .Silver, count: -99)
                } else if rand <= 94 {
                    rewardsDice = RewardsDice(key: .Gold, count: -99)
                } else if rand <= 97{
                    rewardsDice = RewardsDice(key: .Platinum, count: -99)
                } else if rand <= 99 {
                    rewardsDice = RewardsDice(key: .Diamond, count: -99)
                } else {
                    rewardsDice = RewardsDice(key: .Ruby, count: -99)
                }
            }
            
            GameData.addRewardsDiceCount(rewardsDice.key.rawValue, num: 1)
            GameData.save()
            
            let rewardUnlocked = RewardUnlocked(rewardsDice: rewardsDice, rewardType: .Chance)
            
            rewardsDice.openRewardsDiceHandler = openRewardsDice
            rewardsDice.addWobbleAnimation()
            rewardsDice.action = {
                rewardsDice.buttonPressed()
                rewardUnlocked.close()
            }
            
            addChild(rewardUnlocked.createLayer())
            
            // reset rewardTriggered, rewardBoostActivated, and rewardChance
            rewardTriggered = false
            rewardBoostActivated = false
            GameData.resetRewardChance()
        }
        
        // Check for Gameplay Rewards
        var rewardsDice: RewardsDice!
        
        if GameData.gamesPlayed % 100000 == 0 {
            rewardsDice = RewardsDice(key: .Ruby, count: -99)
        } else if GameData.gamesPlayed % 10000 == 0 {
            rewardsDice = RewardsDice(key: .Diamond, count: -99)
        } else if GameData.gamesPlayed % 1000 == 0 {
            rewardsDice = RewardsDice(key: .Platinum, count: -99)
        } else if GameData.gamesPlayed % 100 == 0 {
            rewardsDice = RewardsDice(key: .Gold, count: -99)
        }
        
        if rewardsDice != nil {
            GameData.addRewardsDiceCount(rewardsDice.key.rawValue, num: 1)
            GameData.save()
            
            let rewardUnlocked = RewardUnlocked(rewardsDice: rewardsDice, rewardType: .Gameplay)
            
            rewardsDice.openRewardsDiceHandler = openRewardsDice
            rewardsDice.addWobbleAnimation()
            rewardsDice.action = {
                rewardsDice.buttonPressed()
                rewardUnlocked.close()
            }
            
            addChild(rewardUnlocked.createLayer())
        }
        
        // Show unlocked Coin
        for node in unlockedCoins.reversed() {
            addChild(node.createLayer())
        }
        
        unlockedCoins = []
        
        // Show unlocked Achievements
        for node in unlockedAchievements.reversed() {
            addChild(node.createLayer())
        }
        
        unlockedAchievements = []
        
        // Show Golden Ticket if player ran out of coins
        showGoldenTicket()
    }
    
    func presentGameScene() {
        self.view!.window!.rootViewController!.performSegue(withIdentifier: "showGameScene", sender: self)
    }
    
    func presentMenuScene() {
        Audio.backgroundMusic.removeFromParent()
        
        let transition = SKTransition.flipVertical(withDuration: 0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
}
