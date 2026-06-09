//
//  Location.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

/// Represents every major place or scene the player can visit in the game.
///
/// `Location` works like a simple navigation system for the app.
/// The current location is stored in `GameState.currentLocation`, and
/// `ContentView` uses it to decide which SwiftUI view should be displayed.
///
/// Example:
/// If `currentLocation` is `.caveAndBasin`, then `ContentView` shows
/// `CaveAndBasinView`.
enum Location: Equatable {
    
    // MARK: - Museum Locations
    
    /// The outside of the Banff Park Museum.
    ///
    /// This is where the player begins after the welcome screen.
    /// The player can read the curator's note, find the door code clue,
    /// and unlock the museum door.
    case museumExterior
    
    /// The inside of the Banff Park Museum.
    ///
    /// This acts as the main hub of the game. From here, the player can use
    /// the corkboard, review leads, and travel to investigation locations.
    case museumInterior
    
    
    // MARK: - First Investigation Locations
    
    /// Cave and Basin National Historic Site.
    ///
    /// This location connects the mystery to Banff's hot springs history and
    /// the start of Canada's national park system.
    case caveAndBasin
    
    /// Bow Falls.
    ///
    /// This location contains water, snow, and survey-related clues.
    case bowFalls
    
    /// Banff Springs Hotel.
    ///
    /// This location connects the mystery to old hotel records, sightings,
    /// and strange footprints.
    case banffSpringsHotel
    
    
    // MARK: - Additional Investigation Locations
    
    /// The Banff hot springs area.
    ///
    /// This location expands the mineral spring and symbol storyline.
    case hotSprings
    
    /// Sulphur Mountain Gondola.
    ///
    /// This location connects the investigation to mountain routes and ridge
    /// markers.
    case sulphurMountainGondola
    
    /// Tunnel Mountain.
    ///
    /// This location connects the player to trail evidence and large tracks.
    case tunnelMountain
    
    
    // MARK: - Late-Game Locations
    
    /// Lake Minnewanka.
    ///
    /// This late-game location can be used for final clues connected to water,
    /// hidden history, or the larger Banff mystery.
    case lakeMinnewanka
    
    /// The hidden Bigfoot lair.
    ///
    /// This is a final or secret location connected to the creature mystery.
    case bigfootLair
    
    
    // MARK: - Display Name
    
    /// A player-friendly name for each location.
    ///
    /// This is used in buttons, headers, corkboard leads, maps, and navigation UI.
    var displayName: String {
        switch self {
        case .museumExterior:
            return "Museum Exterior"
            
        case .museumInterior:
            return "Banff Museum"
            
        case .caveAndBasin:
            return "Cave and Basin"
            
        case .bowFalls:
            return "Bow Falls"
            
        case .banffSpringsHotel:
            return "Banff Springs Hotel"
            
        case .hotSprings:
            return "Hot Springs"
            
        case .sulphurMountainGondola:
            return "Sulphur Mountain Gondola"
            
        case .tunnelMountain:
            return "Tunnel Mountain"
            
        case .lakeMinnewanka:
            return "Lake Minnewanka"
            
        case .bigfootLair:
            return "The Hidden Lair"
        }
    }
}
