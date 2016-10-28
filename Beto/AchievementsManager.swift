//
//  AchievementsManager.swift
//  Beto
//
//  Created by Jem on 5/21/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

enum AchievementName: String {
    case GamesPlayed
    case MoneyInTheBank
    case HighestWager
    case MoneyGrabber
    case Unlucky
    case CoinCollector
    case StarCoin
    case BlueWin
    case RedWin
    case GreenWin
    case YellowWin
    case CyanWin
    case PurpleWin
    case Lifeline
    case RewardBoost
    case Reroll
    case ExtraDice
    case DoublePayout
    case TriplePayout
    case Bronze
    case Silver
    case Gold
    case Platinum
    case Diamond
    case Ruby
}

class AchievementsManager {
    fileprivate(set) var list = [Achievement]()
    
    init() {
        /* 
         /********** AchievementName: Sample ***********/
         let sampleValues = [0, 0, 0]
         let sample = Achievement(name: AchievementName.CHANGETHIS.rawValue,
                                  displayName: "CHANGE THIS",
                                  requirementValues: sampleValues,
                                  requirements: ["This is an example \(sampleValues[0])",
                                    "This is an example \(sampleValues[1])",
                                    "This is an example \(sampleValues[2])"], 
                                  rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
         
         list.append(sample)
        */
        
        /********** AchievementName: GamesPlayed ***********/
        let gamesPlayedValues = [100, 1000, 10000]
        let gamesPlayed = Achievement(name: AchievementName.GamesPlayed.rawValue,
                                      displayName: "Can't Put It Down",
                                      requirementValues: gamesPlayedValues,
                                      requirements: ["Play \(gamesPlayedValues[0].formatStringFromNumberShortenMillion()) games",
                                        "Play \(gamesPlayedValues[1].formatStringFromNumberShortenMillion()) games",
                                        "Play \(gamesPlayedValues[2].formatStringFromNumberShortenMillion()) games"],
                                      rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond),
                                        Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(gamesPlayed)
        
        /********** AchievementName: MoneyInTheBank ***********/
        let moneyValues = [10000, 100000, 1000000]
        let moneyInTheBank = Achievement(name: AchievementName.MoneyInTheBank.rawValue,
                                         displayName: "Money in the Bank",
                                         requirementValues: moneyValues,
                                         requirements: ["Reach a highscore of \(moneyValues[0].formatStringFromNumberShortenMillion())",
                                            "Reach a highscore of \(moneyValues[1].formatStringFromNumberShortenMillion())",
                                            "Reach a highscore of \(moneyValues[2].formatStringFromNumberShortenMillion())"],
                                         rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                            Reward(starCoins: 5, rewardsDice: .Diamond),
                                            Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(moneyInTheBank)
        
        
        /********** AchievementName: HighestWager ***********/
        let highestWagerValues = [1000, 10000, 100000]
        let highestWager = Achievement(name: AchievementName.HighestWager.rawValue,
                                       displayName: "The Gambler",
                                       requirementValues: highestWagerValues,
                                       requirements: ["Place a \(highestWagerValues[0].formatStringFromNumberShortenMillion()) bet on any color",
                                        "Place a \(highestWagerValues[1].formatStringFromNumberShortenMillion()) bet on any color",
                                        "Place a \(highestWagerValues[2].formatStringFromNumberShortenMillion()) bet on any color"],
                                       rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond),
                                        Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(highestWager)
        
        
        /********** AchievementName: MoneyGrabber ***********/
        let moneyGrabberValues = [100, 1000, 10000]
        let moneyGrabber = Achievement(name: AchievementName.MoneyGrabber.rawValue,
                                      displayName: "Money Grabber",
                                      requirementValues: moneyGrabberValues,
                                      requirements: ["Win \(moneyGrabberValues[0].formatStringFromNumberShortenMillion()) times",
                                        "Win \(moneyGrabberValues[1].formatStringFromNumberShortenMillion()) times",
                                        "Win \(moneyGrabberValues[2].formatStringFromNumberShortenMillion()) times"],
                                      rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond),
                                        Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(moneyGrabber)
        
        /********** AchievementName: Unlucky ***********/
        let unluckyValues = [100, 1000, 10000]
        let unlucky = Achievement(name: AchievementName.Unlucky.rawValue,
                                       displayName: "Unlucky",
                                       requirementValues: unluckyValues,
                                       requirements: ["Win \(unluckyValues[0].formatStringFromNumberShortenMillion()) times without a reward",
                                        "Win \(unluckyValues[1].formatStringFromNumberShortenMillion()) times without a reward",
                                        "Win \(unluckyValues[2].formatStringFromNumberShortenMillion()) times without a reward"],
                                       rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond),
                                        Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(unlucky)
        

        /********** AchievementName: CoinCollector ***********/
        let coinValues = [1, 4, 7]
        let coinCollector = Achievement(name: AchievementName.CoinCollector.rawValue,
                                        displayName: "Coin Collector",
                                        requirementValues: coinValues,
                                        requirements: ["Unlock a coin in the Coin Vault",
                                            "Unlock \(coinValues[1]) coins in the Coin Vault",
                                            "Unlock all coins in the Coin Vault"],
                                        rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                            Reward(starCoins: 5, rewardsDice: .Diamond),
                                            Reward(starCoins: 10, rewardsDice: .Ruby)])

        list.append(coinCollector)
        
        
        /********** AchievementName: StarCoin ***********/
        let starCoinValues = [25, 50, 100]
        let starCoin = Achievement(name: AchievementName.StarCoin.rawValue,
                                 displayName: "Wish upon a Star",
                                 requirementValues: starCoinValues,
                                 requirements: ["Collect \(starCoinValues[0]) star coins",
                                    "Collect \(starCoinValues[1]) star coins",
                                    "Collect \(starCoinValues[2]) star coins"],
                                 rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond),
                                    Reward(starCoins: 10, rewardsDice: .Ruby)])

        list.append(starCoin)
        
        /********** Color Achievements ***********/
        let colorWinValues = [10, 50, 100]
        
        /********** AchievementName: BlueWin ***********/
        let blueWin = Achievement(name: AchievementName.BlueWin.rawValue,
                                  displayName: "I've Got The Blues",
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Blue, values: colorWinValues),
                                  rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(blueWin)
        
        
        /********** AchievementName: RedWin ***********/
        let redWin = Achievement(name: AchievementName.RedWin.rawValue,
                                  displayName: "One in a Vermillion",
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Red, values: colorWinValues),
                                  rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
    
        list.append(redWin)
        
        
        /********** AchievementName: GreenWin ***********/
        let greenWin = Achievement(name: AchievementName.GreenWin.rawValue,
                                 displayName: "Thank You Verde Much",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Green, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(greenWin)
        
        
        /********** AchievementName: YellowWin ***********/
        let yellowWin = Achievement(name: AchievementName.YellowWin.rawValue,
                                 displayName: "You Had Me At Yellow",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Yellow, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(yellowWin)
        
        
        /********** AchievementName: CyanWin ***********/
        let cyanWin = Achievement(name: AchievementName.CyanWin.rawValue,
                                 displayName: "Cyantifically Proven",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Cyan, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(cyanWin)
        
        
        /********** AchievementName: PurpleWin ***********/
        let purpleWin = Achievement(name: AchievementName.PurpleWin.rawValue,
                                 displayName: "Back to the Fuschia",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Purple, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(purpleWin)
        
        
        /********** Power Up Achievements ***********/
        let powerUpValues = [10, 50, 100]
        
        
        /********** AchievementName: Lifeline ***********/
        let lifeline = Achievement(name: AchievementName.Lifeline.rawValue,
                                   displayName: "Half Off",
                                   requirementValues: powerUpValues,
                                   requirements: powerUpRequirements(AchievementName.Lifeline.rawValue, values: powerUpValues),
                                   rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(lifeline)
        
        /********** AchievementName: RewardBoost ***********/
        let rewardBoost = Achievement(name: AchievementName.RewardBoost.rawValue,
                                   displayName: "Finders Keepers",
                                   requirementValues: powerUpValues,
                                   requirements: powerUpRequirements(AchievementName.RewardBoost.rawValue, values: powerUpValues),
                                   rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(rewardBoost)
        
        
        /********** AchievementName: Reroll ***********/
        let reroll = Achievement(name: AchievementName.Reroll.rawValue,
                                 displayName: "Baby One More Time",
                                 requirementValues: powerUpValues,
                                 requirements: powerUpRequirements(AchievementName.Reroll.rawValue, values: powerUpValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                           Reward(starCoins: 3, rewardsDice: .Platinum),
                                           Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(reroll)
        
        
        /********** AchievementName: ExtraDice ***********/
        let extraDice = Achievement(name: AchievementName.ExtraDice.rawValue,
                                     displayName: "Plus One",
                                     requirementValues: powerUpValues,
                                     requirements: powerUpRequirements(AchievementName.ExtraDice.rawValue, values: powerUpValues),
                                     rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(extraDice)
        
        
        /********** AchievementName: DoublePayout ***********/
        let doublePayout = Achievement(name: AchievementName.DoublePayout.rawValue,
                                     displayName: "Double The Pleasure",
                                     requirementValues: powerUpValues,
                                     requirements: powerUpRequirements(AchievementName.DoublePayout.rawValue, values: powerUpValues),
                                     rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond)])
   
        list.append(doublePayout)
        
        
        /********** AchievementName: TriplePayout ***********/
        let triplePayout = Achievement(name: AchievementName.TriplePayout.rawValue,
                                       displayName: "Three Point Play",
                                       requirementValues: powerUpValues,
                                       requirements: powerUpRequirements(AchievementName.TriplePayout.rawValue, values: powerUpValues),
                                       rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 3, rewardsDice: .Platinum),
                                        Reward(starCoins: 5, rewardsDice: .Diamond)])

        list.append(triplePayout)
        
        
        /********** Rewards Dice Achievements ***********/
        let rewardsDiceValues = [10, 50, 100]

        /********** AchievementName: Bronze ***********/
        let bronze = Achievement(name: AchievementName.Bronze.rawValue,
                                 displayName: "Got a Medal for this",
                                 requirementValues: rewardsDiceValues,
                                 requirements: rewardsDiceRequirements(AchievementName.Bronze.rawValue, values: rewardsDiceValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(bronze)
        
        
        /********** AchievementName: Silver ***********/
        let silver = Achievement(name: AchievementName.Silver.rawValue,
                                 displayName: "A Sterling Find",
                                 requirementValues: rewardsDiceValues,
                                 requirements: rewardsDiceRequirements(AchievementName.Silver.rawValue, values: rewardsDiceValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(silver)
        
        
        /********** AchievementName: Gold ***********/
        let gold = Achievement(name: AchievementName.Gold.rawValue,
                                 displayName: "Golden Retriever",
                                 requirementValues: rewardsDiceValues,
                                 requirements: rewardsDiceRequirements(AchievementName.Gold.rawValue, values: rewardsDiceValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond)])
        
        list.append(gold)
        
        
        /********** AchievementName: Platinum ***********/
        let platinum = Achievement(name: AchievementName.Platinum.rawValue,
                                 displayName: "Worth More Than Gold",
                                 requirementValues: rewardsDiceValues,
                                 requirements: rewardsDiceRequirements(AchievementName.Platinum.rawValue, values: rewardsDiceValues),
                                 rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond),
                                    Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(platinum)
        
        
        /********** AchievementName: Diamond ***********/
        let diamond = Achievement(name: AchievementName.Diamond.rawValue,
                                   displayName: "A Player's Best Friend",
                                   requirementValues: rewardsDiceValues,
                                   requirements: rewardsDiceRequirements(AchievementName.Diamond.rawValue, values: rewardsDiceValues),
                                   rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond),
                                    Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(diamond)
        
        
        /********** AchievementName: Ruby ***********/
        let ruby = Achievement(name: AchievementName.Ruby.rawValue,
                                   displayName: "My Precious",
                                   requirementValues: rewardsDiceValues,
                                   requirements: rewardsDiceRequirements(AchievementName.Ruby.rawValue, values: rewardsDiceValues),
                                   rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond),
                                    Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        list.append(ruby)
    }
    
    func update(_ name: AchievementName) {
        let index = list.index(where: {$0.name == name.rawValue})
        let achievement = list[index!]
        var oldLevel = achievement.level
        
        achievement.calculateLevel()
        achievement.calculateProgress()
        
        let currentLevel = achievement.level
        
        while (currentLevel > oldLevel) {
            oldLevel += 1
            achievement.level = oldLevel
            
            GameData.unlockedAchievementHandler!(achievement)
        }
        
        achievement.calculateLevel()
    }

    fileprivate func colorWinRequirements(_ color: Color, values: [Int]) -> [String] {
        return ["Place \(values[0].formatStringFromNumberShortenMillion()) winning bets on \(color.rawValue)", "Place \(values[1].formatStringFromNumberShortenMillion()) winning bets on \(color.rawValue)", "Place \(values[2].formatStringFromNumberShortenMillion()) winning bets on \(color.rawValue)"]
    }
    
    fileprivate func powerUpRequirements(_ powerUp: String, values: [Int]) -> [String] {
        return ["Use \(powerUp) \(values[0].formatStringFromNumberShortenMillion()) times", "Use \(powerUp) \(values[1].formatStringFromNumberShortenMillion()) times", "Use \(powerUp) \(values[2].formatStringFromNumberShortenMillion()) times"]
    }
    
    fileprivate func rewardsDiceRequirements(_ dice: String, values: [Int]) -> [String] {
        return ["Open \(values[0].formatStringFromNumberShortenMillion()) \(dice) rewards dice", "Open \(values[1].formatStringFromNumberShortenMillion()) \(dice) rewards dice", "Open \(values[2].formatStringFromNumberShortenMillion()) \(dice) rewards dice"]
    }
}
