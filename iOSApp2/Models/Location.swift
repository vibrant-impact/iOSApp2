//
//  Location.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

enum Location: Equatable {
    case museumExterior
    case museumInterior
    
    case caveAndBasin
    case bowFalls
    case banffSpringsHotel
    
    case hotSprings
    case sulphurMountainGondola
    case tunnelMountain
    
    case lakeMinnewanka
    case bigfootLair
    
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
