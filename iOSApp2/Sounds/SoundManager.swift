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
    private var ambiencePlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        configureAudioSession()
    }
    
    
    // MARK: - Sound Effects
    
    func play(_ sound: GameSound, volume: Float = 1.0) {
        playFile(named: sound.fileName, volume: volume)
    }
    
    
    // MARK: - Ambience
    
    func playAmbience(_ ambience: AmbientSound, volume: Float = 0.35) {
        let fileName = ambience.fileName
        
        if let existingPlayer = ambiencePlayers[fileName], existingPlayer.isPlaying {
            existingPlayer.volume = volume
            print("Ambience already playing:", fileName, "volume:", volume)
            return
        }
        
        guard let url = resourceURL(for: fileName) else {
            print("Missing ambience file:", fileName)
            printAvailableWavFiles()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            
            ambiencePlayers[fileName] = player
            
            print("Started ambience:", fileName)
            print("Ambience URL:", url)
            print("Ambience duration:", player.duration)
            print("Ambience is playing:", player.isPlaying)
        } catch {
            print("Could not play ambience:", fileName, error.localizedDescription)
        }
    }
    
    func stopAmbience(_ ambience: AmbientSound) {
        let fileName = ambience.fileName
        
        guard let player = ambiencePlayers[fileName] else {
            print("No ambience to stop:", fileName)
            return
        }
        
        player.stop()
        ambiencePlayers[fileName] = nil
        
        print("Stopped ambience:", fileName)
    }
    
    func stopAllAmbience() {
        for player in ambiencePlayers.values {
            player.stop()
        }
        
        ambiencePlayers.removeAll()
        
        print("Stopped all ambience")
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
            
            print("Audio session configured")
        } catch {
            print("Audio session setup failed:", error.localizedDescription)
        }
    }
    
    private func playFile(named fileName: String, volume: Float) {
        guard let url = resourceURL(for: fileName) else {
            print("Missing sound file:", fileName)
            printAvailableWavFiles()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            players[fileName] = player
            
            print("Played sound:", fileName)
        } catch {
            print("Could not play sound:", fileName, error.localizedDescription)
        }
    }
    
    private func resourceURL(for fileName: String) -> URL? {
        let parts = fileName.split(separator: ".")
        
        guard parts.count == 2 else {
            print("Invalid file name:", fileName)
            return nil
        }
        
        let name = String(parts[0])
        let ext = String(parts[1])
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            return url
        }
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "Sounds") {
            return url
        }
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "Sounds/Ambience") {
            return url
        }
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "Ambience") {
            return url
        }
        
        return nil
    }
    
    private func printAvailableWavFiles() {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: nil) else {
            print("No wav files found in main bundle root.")
            return
        }
        
        print("WAV files found in bundle root:")
        
        for url in urls {
            print("-", url.lastPathComponent)
        }
    }
}
