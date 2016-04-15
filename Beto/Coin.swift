//
//  Coin.swift
//  Beto
//
//  Created by Jem on 3/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: ButtonNode {
    var value: Int
    var unlocked = false
    var coinSelectedHandler: ((Coin) -> ())?

    init(value: Int, unlocked: Bool) {
        self.unlocked = unlocked
        self.value = value
        
        var sprite: String
        
        if unlocked {
            sprite = "coin\(value)"
        } else {
            sprite = "coinLocked"
        }
        
        super.init(defaultButtonImage: sprite, activeButtonImage: sprite)
        
        if (sprite != "coinLocked") {
            activeButton.color = UIColor.blackColor()
            activeButton.colorBlendFactor = 0.3
        }
        
        self.action = coinPressed
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coinPressed() {
        if unlocked {
            coinSelectedHandler!(self)
        }
    }
}


