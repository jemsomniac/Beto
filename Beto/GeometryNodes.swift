//
//  GeometryNodes.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//


import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GeometryNodes {
    
    let floorNode = SCNNode()
    let cameraNode = SCNNode()
    let cubesNode = SCNNode()
    let boundary = Boundary()

    init () {
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIImage(named: "background")!
        floorMaterial.locksAmbientWithDiffuse = false
        
        floorNode.geometry = SCNBox(width: 2.25, height: 0.5, length: 4, chamferRadius: 0)
        
        floorNode.position = SCNVector3(0,0,0)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        floorNode.name = "Floor"
        floorNode.geometry?.materials = [floorMaterial]
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 3.7, 0)
        cameraNode.eulerAngles = SCNVector3Make(Float(-M_PI/2), 0, 0)
                
        addCubesTo(cubesNode)
        
    }
    
    func addNodesTo(parentNode:SCNNode) {
        parentNode.addChildNode(cameraNode)
        parentNode.addChildNode(floorNode)
        parentNode.addChildNode(cubesNode)
     
        boundary.addNodesTo(parentNode)
    }
    
    func addCubesTo(parentNode:SCNNode) {
        let cube1 = Cube(name: "cube1", position: -0.2)
        let cube2 = Cube(name: "cube2", position: 0.0)
        let cube3 = Cube(name: "cube3", position: 0.2)
        cube1.addNodesTo(parentNode)
        cube2.addNodesTo(parentNode)
        cube3.addNodesTo(parentNode)
        
    }
}
