//
//  GameEnding.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import Foundation

enum GameEnding {
    case museumLost
    case partialExhibit
    case museumSaved
    case legendaryLegacy
    
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
