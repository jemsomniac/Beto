//
//  AudioManager.swift
//  Beto
//
//  Created by Jem on 4/13/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class AudioManager {
    
    var placeBetSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
    
    var clearBetSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
    
    var winSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
    
    var lostSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
    
    var backgroundMusic = SKAudioNode(fileNamed: "Mining by Moonlight.mp3")
    
    var soundMuted: Bool
    var musicMuted: Bool
    
    init() {
        soundMuted = false
        musicMuted = false
    }
}