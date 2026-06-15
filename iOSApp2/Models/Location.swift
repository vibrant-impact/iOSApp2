//
//  Location.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

/// Represents every major place or scene the player can visit in the game.
enum Location: Equatable {
    
    // MARK: - Museum Locations
    case museumExterior
    case museumInterior
    
    // MARK: - First Investigation Locations
    case caveAndBasin
    case bowFalls
    case banffSpringsHotel
    
    // MARK: - Additional Investigation Locations
    case hotSprings
    case downtownBanff
    case sulphurMountain
    case observatory
    case lakeMinnewanka
        
    // MARK: - Late-Game Locations
    case tunnelMountain
    case bigfootLair
        
    // MARK: - Display Name
    /// A player-friendly name for each location.

    var displayName: String {
        switch self {
        case .museumExterior:
            return "Museum Exterior"
            
        case .museumInterior:
            return "Banff Park Museum"
            
        case .caveAndBasin:
            return "Cave and Basin"
            
        case .bowFalls:
            return "Bow Falls"
            
        case .banffSpringsHotel:
            return "Banff Springs Hotel"
            
        case .hotSprings:
            return "Upper Hot Springs"
            
        case .downtownBanff:
            return "Downtown Banff"
            
        case .lakeMinnewanka:
            return "Lake Minnewanka"
            
        case .sulphurMountain:
            return "Sulphur Mountain Gondola"
            
        case .observatory:
            return "Weather Station Observatory"
            
        case .tunnelMountain:
            return "Tunnel Mountain"
            
        case .bigfootLair:
            return "The Hidden Lair"
        }
    }
}
