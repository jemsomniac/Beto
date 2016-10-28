//
//  AudioManager.swift
//  Beto
//
//  Created by Jem on 4/13/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit
import SceneKit

class AudioManager {    
    var backgroundMusic: SKAudioNode
    var soundMuted: Bool
    var musicMuted: Bool
    
    var placeBetSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
    
    var clearBetSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Whoosh.wav", waitForCompletion: false)
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
    
    var errorSound: SKAction {
        if !soundMuted {
            return SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
        } else {
            return SKAction()
        }
    }
        
    init() {
        soundMuted = GameData.soundMuted
        musicMuted = GameData.musicMuted
        
        backgroundMusic = SKAudioNode(fileNamed: "Mining by Moonlight.mp3")
    }
    
    func toggleSound() {
        soundMuted = !soundMuted
        GameData.setSound(soundMuted)
        GameData.save()
    }
    
    func toggleMusic() {
        musicMuted = !musicMuted
        GameData.setMusic(musicMuted)
        GameData.save()
    }
}
