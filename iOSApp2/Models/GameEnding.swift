//
//  GameEnding.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import Foundation

/// Represents the possible endings of the game.
///
/// The ending depends on how much the player completes before submitting
/// their final scavenger hunt results.
///
/// In this project, endings are mainly based on:
/// - how many hidden photo symbols the player captures
/// - whether the curator name puzzle is solved
/// - how much evidence has been recovered
enum GameEnding {
    
    /// The weakest ending.
    ///
    /// This ending happens when the player does not recover enough historical
    /// symbols or evidence to help the museum.
    case museumLost
    
    /// A middle ending.
    ///
    /// This ending happens when the player recovers some important evidence,
    /// but not enough to fully complete the exhibit.
    case partialExhibit
    
    /// A strong ending.
    ///
    /// This ending happens when the player collects enough photo symbols and
    /// evidence to save the museum.
    case museumSaved
    
    /// The best ending.
    ///
    /// This ending happens when the player fully completes the scavenger hunt,
    /// solves the curator clue, and recovers the most important parts of the mystery.
    case legendaryLegacy
    
    
    // MARK: - Display Title
    
    /// The title shown to the player on the ending/results screen.
    ///
    /// Each case returns a short dramatic title that summarizes the player's result.
    var title: String {
        switch self {
        case .museumLost:
            return "The Museum Is Lost"
            
        case .partialExhibit:
            return "A Fragile Exhibit Opens"
            
        case .museumSaved:
            return "The Museum Is Saved"
            
        case .legendaryLegacy:
            return "The Legend Lives Forever"
        }
    }
    
    
    // MARK: - Ending Description
    
    /// The story text shown for this ending.
    ///
    /// This gives the player feedback about how their choices and collected
    /// evidence affected the museum's future.
    var description: String {
        switch self {
        case .museumLost:
            return "Too few historical symbols were recovered. Without enough support, the museum closes before the museum curator can prove why the collection matters."
            
        case .partialExhibit:
            return "You recovered enough symbols to earn public interest. The museum survives, but the exhibit is incomplete and the mystery remains partly buried."
            
        case .museumSaved:
            return "Your photographs help create a strong Banff history exhibit. The museum is saved, and the museum curator’s work finally receives the attention it deserves."
            
        case .legendaryLegacy:
            return "You recovered every symbol, solved the curator clue, and secured the museum’s future. The nugget is found, the exhibit becomes famous, and Banff’s hidden story becomes legend."
        }
    }
}
