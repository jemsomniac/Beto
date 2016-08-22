//
//  DiceMaker.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit

enum DiceType {
    case Default
//    case BasicReward
//    case SilverReward
//    case GoldReward
//    case PlatinumReward
//    case DiamondReward
    case DoublePayout
    case TriplePayout
    case DoubleDice
}

class DiceMaker {
    typealias Dice = SCNNode

    private var count = 3
    private var size: CGFloat = 0.33
    
    let diceMaterials: [SCNMaterial]!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: DiceType) {
        var yellowImage = "defaultYellowFace"
        var cyanImage = "defaultCyanFace"
        var purpleImage = "defaultPurpleFace"
        var blueImage = "defaultBlueFace"
        var redImage = "defaultRedFace"
        var greenImage = "defaultGreenFace"
        
        switch type {
        case .Default:
            break
//        case .BasicReward:
//            break
//        case .SilverReward:
//            break
//        case .GoldReward:
//            break
//        case .PlatinumReward:
//            break
//        case .DiamondReward:
//            break
        case .DoubleDice:
            count = 6
            size = 0.28
        case .DoublePayout:
            yellowImage = "doublePayYellowFace"
            cyanImage = "doublePayCyanFace"
            purpleImage = "doublePayPurpleFace"
            blueImage = "doublePayBlueFace"
            redImage = "doublePayRedFace"
            greenImage = "doublePayGreenFace"
        case .TriplePayout:
            yellowImage = "triplePayYellowFace"
            cyanImage = "triplePayCyanFace"
            purpleImage = "triplePayPurpleFace"
            blueImage = "triplePayBlueFace"
            redImage = "triplePayRedFace"
            greenImage = "triplePayGreenFace"
        }
        
        let yellowSide = SCNMaterial()
        yellowSide.diffuse.contents = UIImage(named: yellowImage)
        
        let cyanSide = SCNMaterial()
        cyanSide.diffuse.contents = UIImage(named: cyanImage)
        
        let purpleSide = SCNMaterial()
        purpleSide.diffuse.contents = UIImage(named: purpleImage)
        
        let blueSide = SCNMaterial()
        blueSide.diffuse.contents = UIImage(named: blueImage)
        
        let redSide = SCNMaterial()
        redSide.diffuse.contents = UIImage(named: redImage)
        
        let greenSide = SCNMaterial()
        greenSide.diffuse.contents = UIImage(named: greenImage)

        diceMaterials = [yellowSide, cyanSide, purpleSide, blueSide, redSide, greenSide]
    
    }
    
    func addDiceSetTo(diceNode: SCNNode) {
        for num in 1...count {
            // Initialize position
            let xoffset = CGFloat(num % 3)
            let xposition: CGFloat = -0.2 + (0.2 * xoffset)
            
            var yposition: CGFloat = 0.15
            
            if num > 3 {
                yposition = 1.15
            }

            let position = SCNVector3(xposition, yposition, 1.15)

            let dice = Dice()
            dice.position = position
            dice.geometry = SCNBox(width: size, height: size, length: size, chamferRadius: size/6)
            dice.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))
            dice.geometry!.materials = diceMaterials
            
            dice.physicsBody = SCNPhysicsBody.dynamicBody()
            dice.physicsBody?.mass = CGFloat(10)
            dice.physicsBody?.angularDamping = CGFloat(0.5)   //default 0.1
            dice.physicsBody?.rollingFriction = CGFloat(1.0)  //default 0.0
            
            diceNode.addChildNode(dice)
        }
    }
    
//    func faceMaker(backgroundImage: UIImage, rewardImage: UIImage, rewardPoint: CGPoint) -> UIImage {
//        UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
//        
//        backgroundImage.drawAtPoint(CGPoint(x: 0, y: 0))
//        rewardImage.drawAtPoint(rewardPoint)
//        
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
}
