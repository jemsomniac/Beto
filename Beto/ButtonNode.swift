//
//  ButtonNode.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class ButtonNode: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action: () -> Void
    
    var size: CGSize {
        get {
            return defaultButton.size
        }
        set {
            defaultButton.size = CGSize(width: size.width, height: size.height)
            activeButton.size = CGSize(width: size.width, height: size.height)
        }
    }
    
    init(defaultButtonImage: String, activeButtonImage: String) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.hidden = true
        action = {}
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    convenience init(defaultButtonImage: String) {
        self.init(defaultButtonImage: defaultButtonImage, activeButtonImage: defaultButtonImage)
        activeButton.color = UIColor.blackColor()
        activeButton.colorBlendFactor = 0.3
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        activeButton.hidden = false
        defaultButton.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            activeButton.hidden = false
            defaultButton.hidden = true
        } else {
            activeButton.hidden = true
            defaultButton.hidden = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            action()
        }
        
        activeButton.hidden = true
        defaultButton.hidden = false
    }
    
    func changeTexture(texture: String) {
        defaultButton.texture = SKTexture(imageNamed: texture)
        activeButton.texture = SKTexture(imageNamed: texture)
    }

    func changeTexture(defaultTexture: String, activeTexture: String) {
        defaultButton.texture = SKTexture(imageNamed: defaultTexture)
        activeButton.texture = SKTexture(imageNamed: activeTexture)
    }
}
