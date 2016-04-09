//
//  OverlayScene.swift
//  Beto
//
//  Created by Jem on 3/10/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

import SpriteKit

class OverlayScene: SKScene {
    var board: Board!
    var gameHUD: GameHUD!
    var boardLayer: SKNode!
    var gameHUDLayer: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameData.showUnlockedCoinHandler = showUnlockedCoin
        
        board = Board(scene: self)
        boardLayer = board.createBoardLayer()
        
        gameHUD = GameHUD(scene: self)
        gameHUDLayer = gameHUD.createLayer()
        
        
        addChild(gameHUDLayer)
        addChild(boardLayer)
    }
    
    func showUnlockedCoin() {        
        let reward = Rewards()
        addChild(reward.createRewardsLayer())
    }
}
