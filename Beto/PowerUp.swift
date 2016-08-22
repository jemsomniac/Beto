//
//  PowerUp.swift
//  Beto
//
//  Created by Jem on 8/11/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class PowerUp: ButtonNode {
    private var count: Int
    
    var activatePowerUpHandler: ((PowerUp) -> ())?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(name: String, count: Int) {
        self.count = count
        
        let label = SKLabelNode(text: "\(count)")
        label.fontName = Constant.FontNameExtraBold
        label.fontSize = 18
        label.position = CGPoint(x: 10, y: -20)
        
        let labelShadow = label.createLabelShadow()
        
        super.init(defaultButtonImage: name, activeButtonImage: name)

        self.name = name
        
        activeButton.color = UIColor.blackColor()
        activeButton.colorBlendFactor = 0.3
        
        addChild(labelShadow)
        addChild(label)
        
        self.action = buttonPressed
    }
    
    func buttonPressed() {
        if count > 0 {
            activatePowerUpHandler!(self)            
        }
    }
}
