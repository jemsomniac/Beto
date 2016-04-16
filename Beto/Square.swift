//
//  Square.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

enum Color: Int {
    case Blue, Red, Green, Yellow, Cyan, Purple

    var name: String {
        let colors = ["Blue", "Red", "Green", "Yellow", "Cyan", "Purple"]

        return colors[rawValue]
    }

    var squareSpriteName: String {
        return name + "Square"
    }

}

class Square: ButtonNode {
    var wager = 0
    var color: Color
    var label: SKLabelNode
    
    var placeBetHandler: ((Square) -> ())?
    
    init(color: Color, defaultButtonImage: String, activeButtonImage: String) {
        self.color = color
        
        label = SKLabelNode(fontNamed: Constant.FontName)
        label.text = "\(wager)"
        label.hidden = true
        

        super.init(defaultButtonImage: defaultButtonImage, activeButtonImage: activeButtonImage)
        
        addChild(label)
        self.action = squarePressed
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func squarePressed() {
        placeBetHandler!(self)
    }
}
