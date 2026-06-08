//
//  PhotoSymbol.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import Foundation

struct PhotoSymbol: Identifiable, Equatable {
    let id: String
    let location: Location
    let symbolName: String
    let historicalNote: String
    let secretLetter: String
}

extension PhotoSymbol {
    static let museumExterior = PhotoSymbol(
        id: "photo_symbol_museum_exterior",
        location: .museumExterior,
        symbolName: "Museum Wall Symbol",
        historicalNote: "The Banff Park Museum is one of the oldest natural history museums in Western Canada. Its wooden architecture and preserved specimens reflect an early era of national park storytelling.",
        secretLetter: "J"
    )
    
    static let caveAndBasin = PhotoSymbol(
        id: "photo_symbol_cave_and_basin",
        location: .caveAndBasin,
        symbolName: "Mineral Spring Symbol",
        historicalNote: "Cave and Basin is closely tied to Banff’s origin as Canada’s first national park. The mineral springs helped shape the protected landscape that would become Banff National Park.",
        secretLetter: "A"
    )
    
    static let bowFalls = PhotoSymbol(
        id: "photo_symbol_bow_falls",
        location: .bowFalls,
        symbolName: "Bow River Survey Mark",
        historicalNote: "Bow Falls sits along the Bow River, a waterway that has shaped travel, settlement, tourism, and ecology throughout the Bow Valley.",
        secretLetter: "C"
    )
    
    static let banffSpringsHotel = PhotoSymbol(
        id: "photo_symbol_banff_springs_hotel",
        location: .banffSpringsHotel,
        symbolName: "Railway Crest",
        historicalNote: "The Banff Springs Hotel was developed by the Canadian Pacific Railway, helping transform Banff into an international mountain destination.",
        secretLetter: "Q"
    )
    
    static let hotSprings = PhotoSymbol(
        id: "photo_symbol_hot_springs",
        location: .hotSprings,
        symbolName: "Thermal Spring Marker",
        historicalNote: "Banff’s thermal springs have drawn people for generations. Long before tourism brochures, warm mineral water made these places important winter refuges.",
        secretLetter: "U"
    )
    
    static let sulphurMountain = PhotoSymbol(
        id: "photo_symbol_sulphur_mountain",
        location: .sulphurMountainGondola,
        symbolName: "Summit Marker",
        historicalNote: "Sulphur Mountain offers a high view over the Bow Valley. From above, old routes, ridges, and waterways become easier to understand as one connected landscape.",
        secretLetter: "E"
    )
    
    static let tunnelMountain = PhotoSymbol(
        id: "photo_symbol_tunnel_mountain",
        location: .tunnelMountain,
        symbolName: "Trailhead Carving",
        historicalNote: "Tunnel Mountain’s name comes from an abandoned railway tunnel plan. The mountain kept the name, even though the tunnel itself was never built.",
        secretLetter: "L"
    )
    
    static let lakeMinnewanka = PhotoSymbol(
        id: "photo_symbol_lake_minnewanka",
        location: .lakeMinnewanka,
        symbolName: "Flooded Townsite Mark",
        historicalNote: "Lake Minnewanka holds stories beneath the surface, including submerged traces of earlier human activity and changing water levels over time.",
        secretLetter: "I"
    )
    
    static let bigfootLair = PhotoSymbol(
        id: "photo_symbol_bigfoot_lair",
        location: .bigfootLair,
        symbolName: "Ancient Handprint",
        historicalNote: "Deep in the hidden lair, a handprint-like marking suggests the old stories may have preserved something real, misunderstood, and carefully hidden.",
        secretLetter: "N"
    )
    
    static let museumInterior = PhotoSymbol(
        id: "photo_symbol_museum_interior",
        location: .museumInterior,
        symbolName: "Completed Exhibit Emblem",
        historicalNote: "The museum’s final exhibit connects Banff’s official history with the hidden clues gathered across the valley. The story survives because someone followed every thread.",
        secretLetter: "E"
    )
    
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
    
    static func symbol(for location: Location) -> PhotoSymbol? {
        all.first { $0.location == location }
    }
}
