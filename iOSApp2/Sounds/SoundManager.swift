//
//  SoundManager.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import AVFoundation
import SwiftUI

final class SoundManager {
    
    static let shared = SoundManager()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    private init() {
        configureAudioSession()
    }
    
    
    // MARK: - Public
    
    func play(_ sound: GameSound, volume: Float = 1.0) {
        playFile(named: sound.fileName, volume: volume)
    }
    
    
    // MARK: - Private
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default,
                options: [.mixWithOthers]
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed:", error.localizedDescription)
        }
    }
    
    private func playFile(named fileName: String, volume: Float) {
        let parts = fileName.split(separator: ".")
        
        guard parts.count == 2 else {
            print("Invalid sound file name:", fileName)
            return
        }
        
        let name = String(parts[0])
        let ext = String(parts[1])
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Missing sound file:", fileName)
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            players[fileName] = player
        } catch {
            print("Could not play sound:", fileName, error.localizedDescription)
        }
    }
}
