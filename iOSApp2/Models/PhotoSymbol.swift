//
//  PhotoSymbol.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import Foundation

/// Represents one hidden photo symbol that the player can discover and photograph.
///
/// Photo symbols are optional collectible clues placed across the game's locations.
/// Each symbol includes:
/// - a location where it can be found
/// - a name for the symbol
/// - a historical note about Banff
/// - a secret letter used for the curator name puzzle
///
/// The secret letters combine to spell the curator's name:
/// `JACQUELINE`
struct PhotoSymbol: Identifiable, Equatable {
    
    /// A unique string used to identify this photo symbol.
    ///
    /// This id is stored in `GameState` after the player photographs the symbol.
    ///
    /// Example:
    /// `"photo_symbol_cave_and_basin"`
    let id: String
    
    /// The game location where this symbol can be found.
    ///
    /// Example:
    /// `.caveAndBasin`
    let location: Location
    
    /// The display name shown to the player after photographing the symbol.
    ///
    /// Example:
    /// `"Mineral Spring Symbol"`
    let symbolName: String
    
    /// A short historical explanation connected to the symbol's location.
    ///
    /// These notes help connect the scavenger hunt to real Banff history.
    let historicalNote: String
    
    /// A hidden letter revealed when the player photographs the symbol.
    ///
    /// The letters from all photo symbols can be combined to solve the
    /// curator name puzzle.
    let secretLetter: String
}


// MARK: - Photo Symbol Library

extension PhotoSymbol {
    
    // MARK: - Museum Symbols
    
    /// Hidden symbol found outside the Banff Park Museum.
    ///
    /// This introduces the photo scavenger hunt and gives the first secret letter.
    static let museumExterior = PhotoSymbol(
        id: "photo_symbol_museum_exterior",
        location: .museumExterior,
        symbolName: "Museum Wall Symbol",
        historicalNote: "The Banff Park Museum is one of the oldest natural history museums in Western Canada. Its wooden architecture and preserved specimens reflect an early era of national park storytelling.",
        secretLetter: "J"
    )
    
    /// Hidden symbol found inside the museum after enough progress has been made.
    ///
    /// This final museum symbol completes the curator name puzzle.
    static let museumInterior = PhotoSymbol(
        id: "photo_symbol_museum_interior",
        location: .museumInterior,
        symbolName: "Completed Exhibit Emblem",
        historicalNote: "The museum’s final exhibit connects Banff’s official history with the hidden clues gathered across the valley. The story survives because someone followed every thread.",
        secretLetter: "E"
    )
    
    
    // MARK: - Investigation Location Symbols
    
    /// Hidden symbol found at Cave and Basin.
    ///
    /// This connects the mystery to Banff's mineral springs and national park history.
    static let caveAndBasin = PhotoSymbol(
        id: "photo_symbol_cave_and_basin",
        location: .caveAndBasin,
        symbolName: "Mineral Spring Symbol",
        historicalNote: "Cave and Basin is closely tied to Banff’s origin as Canada’s first national park. The mineral springs helped shape the protected landscape that would become Banff National Park.",
        secretLetter: "A"
    )
    
    /// Hidden symbol found at Bow Falls.
    ///
    /// This connects the mystery to the Bow River and its importance in the valley.
    static let bowFalls = PhotoSymbol(
        id: "photo_symbol_bow_falls",
        location: .bowFalls,
        symbolName: "Bow River Survey Mark",
        historicalNote: "Bow Falls sits along the Bow River, a waterway that has shaped travel, settlement, tourism, and ecology throughout the Bow Valley.",
        secretLetter: "C"
    )
    
    /// Hidden symbol found at the Banff Springs Hotel.
    ///
    /// This connects the mystery to railway tourism and Banff's development as
    /// a mountain destination.
    static let banffSpringsHotel = PhotoSymbol(
        id: "photo_symbol_banff_springs_hotel",
        location: .banffSpringsHotel,
        symbolName: "Railway Crest",
        historicalNote: "The Banff Springs Hotel was developed by the Canadian Pacific Railway, helping transform Banff into an international mountain destination.",
        secretLetter: "Q"
    )
    
    /// Hidden symbol found at the hot springs.
    ///
    /// This supports the mineral water storyline and adds another letter to
    /// the curator name puzzle.
    static let hotSprings = PhotoSymbol(
        id: "photo_symbol_hot_springs",
        location: .hotSprings,
        symbolName: "Thermal Spring Marker",
        historicalNote: "Banff’s thermal springs have drawn people for generations. Long before tourism brochures, warm mineral water made these places important winter refuges.",
        secretLetter: "U"
    )
    
    /// Hidden symbol found at Sulphur Mountain.
    ///
    /// This symbol connects high viewpoints, mountain routes, and landscape clues.
    static let sulphurMountain = PhotoSymbol(
        id: "photo_symbol_sulphur_mountain",
        location: .sulphurMountainGondola,
        symbolName: "Summit Marker",
        historicalNote: "Sulphur Mountain offers a high view over the Bow Valley. From above, old routes, ridges, and waterways become easier to understand as one connected landscape.",
        secretLetter: "E"
    )
    
    /// Hidden symbol found at Tunnel Mountain.
    ///
    /// This symbol connects the mystery to railway plans and trail history.
    static let tunnelMountain = PhotoSymbol(
        id: "photo_symbol_tunnel_mountain",
        location: .tunnelMountain,
        symbolName: "Trailhead Carving",
        historicalNote: "Tunnel Mountain’s name comes from an abandoned railway tunnel plan. The mountain kept the name, even though the tunnel itself was never built.",
        secretLetter: "L"
    )
    
    
    // MARK: - Late-Game Symbols
    
    /// Hidden symbol found at Lake Minnewanka.
    ///
    /// This connects the mystery to submerged history and changing water levels.
    static let lakeMinnewanka = PhotoSymbol(
        id: "photo_symbol_lake_minnewanka",
        location: .lakeMinnewanka,
        symbolName: "Flooded Townsite Mark",
        historicalNote: "Lake Minnewanka holds stories beneath the surface, including submerged traces of earlier human activity and changing water levels over time.",
        secretLetter: "I"
    )
    
    /// Hidden symbol found in the Bigfoot lair.
    ///
    /// This symbol connects the legendary creature storyline to the larger
    /// historical mystery.
    static let bigfootLair = PhotoSymbol(
        id: "photo_symbol_bigfoot_lair",
        location: .bigfootLair,
        symbolName: "Ancient Handprint",
        historicalNote: "Deep in the hidden lair, a handprint-like marking suggests the old stories may have preserved something real, misunderstood, and carefully hidden.",
        secretLetter: "N"
    )
    
    
    // MARK: - Complete Symbol List
    
    /// A complete list of all photo symbols in the game.
    ///
    /// The order matters because the secret letters spell:
    /// `JACQUELINE`
    ///
    /// This array is used to:
    /// - count total photo symbols
    /// - look up symbols by location
    /// - display collected photo progress
    /// - check whether the player found every symbol
    static let all: [PhotoSymbol] = [
        museumExterior,
        caveAndBasin,
        bowFalls,
        banffSpringsHotel,
        hotSprings,
        sulphurMountain,
        tunnelMountain,
        lakeMinnewanka,
        bigfootLair,
        museumInterior
    ]
    
    
    // MARK: - Symbol Lookup
    
    /// Finds the photo symbol for a specific location.
    ///
    /// This is useful when a view needs to know whether the current location
    /// has a hidden photo symbol.
    ///
    /// - Parameter location: The location to search for.
    /// - Returns: The matching `PhotoSymbol`, or `nil` if that location has no symbol.
    static func symbol(for location: Location) -> PhotoSymbol? {
        all.first { $0.location == location }
    }
}
