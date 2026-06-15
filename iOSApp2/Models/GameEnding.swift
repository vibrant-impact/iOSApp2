//
//  GameEnding.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import Foundation

enum GameEnding {
    
    /// The weakest ending.
    case museumLost
    case interestReignited
    case newFunding
    case legendaryLegacy
    
    
    // MARK: - Display Title
    
    /// The title shown to the player on the ending/results screen.
    var title: String {
        switch self {
        case .museumLost:
            return "The Museum Is Lost"
            
        case .interestReignited:
            return "Local Interest Reignited"
            
        case .newFunding:
            return "New Funding for the Museum"
            
        case .legendaryLegacy:
            return "The Legends Live Forever"
        }
    }
    
    
    // MARK: - Ending Description
    
    /// The story text shown for this ending.
    var description: String {
        switch self {
        case .museumLost:
            return "The museum lacks the public buzz to fight the developers. It gets permanently shut down, boarded up, and its artifacts archived."
            
        case .interestReignited:
            return "Your articles spark local interest! The museum is saved from closure, and you receive a 10% discount at Banff shops."
            
        case .newFunding:
            return "The series goes viral, bringing international tourism and funding. A new 'Legends of the Rockies' exhibit is launched. You get a 20% discount at Banff shops."
            
        case .legendaryLegacy:
            return "You solve the curator's anagram (S-A-S-Q-U-A-T-C-H), unlocking the $5,000 draw entry. Plus, the narrative twist triggers: You wake up outside, think it was a dream, but find the massive Lost Lemon Gold Nugget in your coat pocket. You anonymously donate it, securing the museum's legendary status forever."
        }
    }
}
