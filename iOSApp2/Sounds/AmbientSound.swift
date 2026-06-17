//
//  AmbientSound.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-16.
//

import Foundation

enum AmbientSound {
    case snowyExterior
    case townStreet
    case waterfall
    case hotelExterior
    case mountainWind
    case caveDrip
    case museumInterior
    case fireplace
    
    var fileName: String {
        switch self {
        case .snowyExterior:
            return "ambience_snowy_exterior.wav"
        case .townStreet:
            return "ambience_town_street.wav"
        case .waterfall:
            return "ambience_waterfall.wav"
        case .hotelExterior:
            return "ambience_hotel_exterior.wav"
        case .mountainWind:
            return "ambience_mountain_wind.wav"
        case .caveDrip:
            return "ambience_cave_drip.wav"
        case .museumInterior:
            return "ambience_museum_interior.wav"
        case .fireplace:
            return "ambience_fireplace.wav"
        }
    }
}
