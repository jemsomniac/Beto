//
//  GameDataManager.swift
//  Beto
//
//  Created by Jem on 2/23/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class GameDataManager {
    // Keys
    private let starCoinsKey = "starCoins"
    private let coinsKey = "coins"
    private let highscoreKey = "highscore"
    private let betDenominationKey = "betDenomination"
    private let coinsUnlockedKey = "coinsUnlocked"
    private let soundMutedKey = "soundMuted"
    private let musicMutedKey = "musicMuted"
    private let currentThemeNameKey = "currentThemeName"
    private let unlockedThemesKey = "unlockedThemes"
    private let powerUpsKey = "powerUps"
    private let rewardsDiceKey = "rewardsDice"
    
    private let gamesPlayedKey = "gamesPlayed"
    private let redWinCountKey = "redWinCount"
    private let blueWinCountKey = "blueWinCount"
    private let greenWinCountKey = "greenWinCount"
    private let yellowWinCountKey = "yellowWinCount"
    private let cyanWinCountKey = "cyanWinCount"
    private let purpleWinCountKey = "purpleWinCount"
    private let highestWagerKey = "highestWager"
    
    // Plist Variables
    private(set) var starCoins: Int
    private(set) var coins: Int
    private(set) var highscore: Int
    private(set) var betDenomination: Int
    private(set) var coinsUnlocked: Int
    private(set) var soundMuted: Bool
    private(set) var musicMuted: Bool
    private(set) var currentThemeName: String
    private(set) var unlockedThemes: [String]
    private(set) var powerUps: [String:Int]
    private(set) var rewardsDice: [String: Int]
    
    private(set) var gamesPlayed: Int
    private(set) var redWinCount: Int
    private(set) var blueWinCount: Int
    private(set) var greenWinCount: Int
    private(set) var yellowWinCount: Int
    private(set) var cyanWinCount: Int
    private(set) var purpleWinCount: Int
    private(set) var highestWager: Int
    
    // Non-plist variables
    private(set) var theme: Theme
    private(set) var rewardChance: Int
    
    var unlockedCoinHandler: (() -> ())?
    var unlockedLevelHandler: ((Achievement) -> ())?
        
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch {
                    print("Error copying file")
                }
            } else {
                print("GameData.plist not found. Please make sure it is part of the bundle.")
            }
        }
        
        let dict = NSDictionary(contentsOfFile: path)!
        
        starCoins = dict.objectForKey(starCoinsKey) as! Int
        coins = dict.objectForKey(coinsKey) as! Int
        highscore = dict.objectForKey(highscoreKey) as! Int
        betDenomination = dict.objectForKey(betDenominationKey) as! Int
        coinsUnlocked = dict.objectForKey(coinsUnlockedKey) as! Int
        soundMuted = dict.objectForKey(soundMutedKey) as! Bool
        musicMuted = dict.objectForKey(musicMutedKey) as! Bool
        currentThemeName = dict.objectForKey(currentThemeNameKey) as! String
        unlockedThemes = dict.objectForKey(unlockedThemesKey) as! [String]
        powerUps = dict.objectForKey(powerUpsKey) as! [String:Int]
        rewardsDice = dict.objectForKey(rewardsDiceKey) as! [String:Int]
        
        gamesPlayed = dict.objectForKey(gamesPlayedKey) as! Int
        redWinCount = dict.objectForKey(redWinCountKey) as! Int
        blueWinCount = dict.objectForKey(blueWinCountKey) as! Int
        greenWinCount = dict.objectForKey(greenWinCountKey) as! Int
        yellowWinCount = dict.objectForKey(yellowWinCountKey) as! Int
        cyanWinCount = dict.objectForKey(cyanWinCountKey) as! Int
        purpleWinCount = dict.objectForKey(purpleWinCountKey) as! Int
        highestWager = dict.objectForKey(highestWagerKey) as! Int

        theme = Theme(themeName: currentThemeName, unlocked: true)
        rewardChance = 0
    }
    
    func save() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        // save values
        dict.setObject(starCoins, forKey: starCoinsKey)
        dict.setObject(coins, forKey: coinsKey)
        dict.setObject(highscore, forKey: highscoreKey)
        dict.setObject(betDenomination, forKey: betDenominationKey)
        dict.setObject(coinsUnlocked, forKey: coinsUnlockedKey)
        dict.setObject(soundMuted, forKey: soundMutedKey)
        dict.setObject(musicMuted, forKey: musicMutedKey)
        dict.setObject(currentThemeName, forKey: currentThemeNameKey)
        dict.setObject(unlockedThemes, forKey: unlockedThemesKey)
        dict.setObject(powerUps, forKey: powerUpsKey)
        dict.setObject(rewardsDice, forKey: rewardsDiceKey)
        
        dict.setObject(gamesPlayed, forKey: gamesPlayedKey)
        dict.setObject(redWinCount, forKey: redWinCountKey)
        dict.setObject(blueWinCount, forKey: blueWinCountKey)
        dict.setObject(greenWinCount, forKey: greenWinCountKey)
        dict.setObject(yellowWinCount, forKey: yellowWinCountKey)
        dict.setObject(cyanWinCount, forKey: cyanWinCountKey)
        dict.setObject(purpleWinCount, forKey: purpleWinCountKey)
        dict.setObject(highestWager, forKey: highestWagerKey)
        
        // write to GameData.plist
        dict.writeToFile(path, atomically: true)
    }
    
    func changeTheme(theme: Theme) {
        currentThemeName = theme.name
        self.theme = theme
    }
    
    func addPurchasedTheme(themeName: String) {
        unlockedThemes.append(themeName)
    }
    
    func setMusic(musicMuted: Bool) {
        self.musicMuted = musicMuted
    }
    
    func setSound(soundMuted: Bool) {
        self.soundMuted = soundMuted
    }
    
    func setDenomination(value: Int) {
        betDenomination = value
    }
    
    func addStarCoins(amount: Int) {
        starCoins += amount
    }
    
    func subtractStarCoins(amount: Int) {
        starCoins -= amount
    }
    
    func subtractCoins(amount: Int) {
        coins -= amount
    }
    
    func addCoins(amount: Int) {
        let max = 999999999
        
        if (coins + amount) > max {
            coins = max
            
            // DELETE: Add ultimate reward when player reach max
        } else {
            coins += amount
        }
        
        if coins > highscore {
            highscore = coins
            Achievements.update(.MoneyInTheBank)
            
            var index = 0

            for value in Constant.CoinUnlockedAt {                
                if highscore >= value {
                    index = 1 + Constant.CoinUnlockedAt.indexOf(value)!
                } else {
                    break
                }
            }
            
            while index > coinsUnlocked {
                coinsUnlocked += 1
                unlockedCoinHandler!()
            }
            
            Achievements.update(.CoinCollector)
            }
    }
    
    func incrementRewardChance(num: Int) {
        // DELETE: Tweak tweak
        if rewardChance + num <= 5 {
            rewardChance += num
        } else {
            rewardChance = 5
        }
    }
    
    func resetRewardChance() {
        rewardChance = 0
    }
    
    func incrementGamesPlayed() {
        gamesPlayed += 1
        Achievements.update(.GamesPlayed)
    }
    
    func incrementWinCount(color: Color) {
        switch color {
        case .Blue:
            blueWinCount += 1
            Achievements.update(.BlueWin)
        case .Red:
            redWinCount += 1
            Achievements.update(.RedWin)
        case .Green:
            greenWinCount += 1
            Achievements.update(.GreenWin)
        case .Yellow:
            yellowWinCount += 1
            Achievements.update(.YellowWin)
        case .Cyan:
            cyanWinCount += 1
            Achievements.update(.CyanWin)
        case .Purple:
            purpleWinCount += 1
            Achievements.update(.PurpleWin)
        }
    }
    
    func updateHighestWager(wager: Int) {
        if wager > highestWager {
            highestWager = wager
            Achievements.update(.HighestWager)
        }
    }
    
    func addPowerUpCount(powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value + num
        }
    }
    
    func subtractPowerUpCount(powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value - num
        }
    }
    
    func getRewardsDiceCount(diceKey: String) -> Int {
        if let value = rewardsDice[diceKey] {
            return value
        } else {
            return -1
        }
    }
    
    func addRewardsDiceCount(diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value + num
        }
    }
    
    func subtractRewardsDiceCount(diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value - num
        }
    }
}