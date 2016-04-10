//
//  GameScene.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit

class GameScene: SCNScene, SCNSceneRendererDelegate {
    
    var didNotRunYet1 = true //dirty - TODO: Delete
    var didNotRunYet2 = true //dirty - TODO: Delete
    var didNotRunYet3 = true //dirty - TODO: Delete
    
    var geometryNodes = GeometryNodes()
    var shouldCheckMovement = false
    var winningSquares = [String]()

    var cubeRestHandler: (()->())?
    
    override init() {
        super.init()
        
        geometryNodes.addNodesTo(rootNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nearlyAtRest(node: SCNNode) -> Bool {
        let dx = Float((node.physicsBody?.velocity.x)!)
        let dy = Float((node.physicsBody?.velocity.y)!)
        let dz = Float((node.physicsBody?.velocity.z)!)

        let speed = sqrtf(dx*dx+dy*dy+dz*dz)
        
        let x = Float((node.physicsBody?.angularVelocity.x)!)
        let y = Float((node.physicsBody?.angularVelocity.y)!)
        let z = Float((node.physicsBody?.angularVelocity.z)!)
        
        let angularSpeed = sqrtf(x*x+y*y+z*z)

        return (speed < 0.001 || angularSpeed < 0.9)
    }
    
    func getUpSide(node: SCNNode) -> String {
        
        let rotation = node.presentationNode.rotation; //SCNVector4
        var invRotation = rotation; invRotation.w = -invRotation.w; //SCNVector4
        
        let up = SCNVector3Make(0,1,0);
        
        //rotate up by invRotation
        let transform = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z); //SCNMatrix4
        let glkTransform = SCNMatrix4ToGLKMatrix4(transform); //GLKMatrix4
        let glkUp = SCNVector3ToGLKVector3(up); //GLKVector3
        let rotatedUp = GLKMatrix4MultiplyVector3(glkTransform, glkUp); //GLKVector3
        
        //build box normals (arbitrary order here)
        
        var boxNormals: [GLKVector3] = [GLKVector3(v: (0,0,1)),
            GLKVector3(v: (1,0,0)),
            GLKVector3(v: (0,0,-1)),
            GLKVector3(v: (-1,0,0)),
            GLKVector3(v: (0,1,0)),
            GLKVector3(v: (0,-1,0))]
        
        var bestIndex: Int = 0;
        var maxDot: Float = -1;
        
        for  i in 0...5 {
            let dot: Float = GLKVector3DotProduct( boxNormals[i] , rotatedUp ) ;
            
            if(dot > maxDot){
                maxDot = dot;
                bestIndex = i;
            }
        }
        
        var colorUp = ["Yellow", "Cyan", "Purple", "Blue","Red", "Green"]
        
        print("NodeName=\(node.name) ; FaceUp=\(colorUp[bestIndex])")
        return colorUp[bestIndex];
    }
    
    
    func resetCubes() {
        
        var count = 0.0
    
        for node in geometryNodes.cubesNode.childNodes {
            node.physicsBody?.velocity = SCNVector3(0,0,0)
            node.physicsBody?.angularVelocity = SCNVector4(0,0,0,0)
            node.position = SCNVector3((-0.25*count+0.17),0.15,1.15)
            node.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))
            count+=1
        }
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if shouldCheckMovement {
            for node in geometryNodes.cubesNode.childNodes {
                if node.physicsBody!.isResting || nearlyAtRest(node) {
                    
                    var actions = [SCNAction]()
                    actions.append(SCNAction.fadeOutWithDuration(0.75))
                    actions.append(SCNAction.removeFromParentNode())
                    let sequence = SCNAction.sequence(actions)
                    
                    //TODO: Need to display text of side up or wagers

                    if node.name == "cube1" && didNotRunYet1 {
                        node.runAction(sequence)
                        self.winningSquares.append(self.getUpSide(node))
                        cubeRestHandler!()
                        didNotRunYet1 = false
                    } else if node.name == "cube2" && didNotRunYet2 {
                        node.runAction(sequence)
                        self.winningSquares.append(self.getUpSide(node))
                        cubeRestHandler!()
                        didNotRunYet2 = false
                    } else if node.name == "cube3" && didNotRunYet3 {
                        node.runAction(sequence)
                        self.winningSquares.append(self.getUpSide(node))
                        cubeRestHandler!()
                        didNotRunYet3 = false
                    }
                }
            }
        }
        
        if winningSquares.count == 3 {
            shouldCheckMovement = false
        }
        
        if geometryNodes.cubesNode.childNodes.count == 0 {
            print("all 3 cubes are gone")
            didNotRunYet1 = true
            didNotRunYet2 = true
            didNotRunYet3 = true
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
