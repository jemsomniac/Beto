//
//  Constant.swift
//  Beto
//
//  Created by Jem on 2/24/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

let BetValues = [1, 5, 10, 50, 100, 1000, 10000, 100000]
let GameData = GameDataManager()
let Audio = AudioManager()

struct Constant {
    static let Margin: CGFloat = 10
    static let ScaleFactor: CGFloat = UIScreen.mainScreen().bounds.width / 320.0
    static let FontName = "Futura Condensed Medium"
}

struct ScreenSize {
    static let size = UIScreen.mainScreen().bounds
    static let width = UIScreen.mainScreen().bounds.width
    static let height = UIScreen.mainScreen().bounds.height
}

