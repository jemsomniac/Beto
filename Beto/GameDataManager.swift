//
//  GameDataManager.swift
//  Beto
//
//  Created by Jem on 2/23/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class GameDataManager {
    var coins = 0
    var highscore = 0
    var defaultBetValue = 1
    var unlockedCoins = 0
    
    var showUnlockedCoinHandler: (() -> ())?
    
    init() {
        // load existing coins
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
        
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            // load values
            coins = dict.objectForKey("coins") as! Int
            highscore = dict.objectForKey("highscore") as! Int
            defaultBetValue = dict.objectForKey("defaultBetValue") as! Int
            unlockedCoins = dict.objectForKey("unlockedCoins") as! Int
        } else {
            print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used.")
        }
    }
    
    func saveGameData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        // save values
        dict.setObject(coins, forKey: "coins")
        dict.setObject(highscore, forKey: "highscore")
        dict.setObject(defaultBetValue, forKey: "defaultBetValue")
        dict.setObject(unlockedCoins, forKey: "unlockedCoins")
        
        // write to GameData.plist
        dict.writeToFile(path, atomically: false)
    }
    
    func didUnlockCoin() -> Bool {
        var value = 0
        
        // DELETE: Bug here where coins doesnt get unlocked right away when treshold is reached.
        
        if highscore >= 1000000 {
            value = 7
        } else if highscore >= 100000 {
            value = 6
        } else if highscore >= 10000 {
            value = 5
        } else if highscore >= 5000 {
            value = 4
        } else if highscore >= 1000 {
            value = 3
        } else if highscore >= 200 {
            value = 2
        } else if highscore >= 100 {
            value = 1
        }
        
        if value > unlockedCoins {
            unlockedCoins = value
            showUnlockedCoinHandler!()
            
            return true
        }
        
        return false
    }
}