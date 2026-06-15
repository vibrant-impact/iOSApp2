//
//  Photo.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-13.
//

import Foundation

struct Photo: Identifiable, Equatable {
    let id: String
    let location: Location
    let photoName: String
    let historicalNote: String
    let secretLetter: String
}


// MARK: - Photo Library

extension Photo {
    
    static let museumExterior = Photo(
        id: "photo_museum_bigfoot_footprint",
        location: .museumExterior,
        photoName: "Mysterious Massive Footprint",
        historicalNote: "Legends surrounding Bigfoot in the Canadian Rockies trace back centuries, with Indigenous communities sharing rich oral traditions about powerful wilderness guardians — beings to be respected rather than hunted.",
        secretLetter: "A"
    )
    
    static let bowFalls = Photo(
        id: "photo_bow_falls_douglas_fir",
        location: .bowFalls,
        photoName: "Douglas Fir Trees",
        historicalNote: "The Stoney Nakoda name for the river is Mînî Thnî Wapta, meaning Cold Water River. The area surrounding Bow Falls was highly prized for gathering Douglas fir wood, valued for its flexibility and strength in crafting hunting bows.",
        secretLetter: "S"
    )
    
    static let caveAndBasin = Photo(
        id: "photo_cave_and_basin_vent",
        location: .caveAndBasin,
        photoName: "Cave and Basin Vent Hole",
        historicalNote: "Before this area became part of a national park, local Indigenous groups considered these thermal waters a sacred place of peace and healing. In 1883, three CPR rail workers descended through this ceiling vent, sparking a gold-rush-style battle for ownership.",
        secretLetter: "T"
    )
    
    static let banffSpringsHotel = Photo(
        id: "photo_banff_springs_hotel_ghost_bride",
        location: .banffSpringsHotel,
        photoName: "Ghost Bride in the Window",
        historicalNote: "In the early 1930s, a young bride reportedly tripped on the hotel's grand staircase after her gown caught fire from nearby candlelight. Hotel staff and visitors have since reported seeing her spectral figure dancing alone in the mountain-view ballroom.",
        secretLetter: "C"
    )
    
    static let downtownBanff = Photo(
        id: "photo_downtown_bigfoot_ice_sculpture",
        location: .downtownBanff,
        photoName: "Bigfoot Ice Sculpture",
        historicalNote: "Banff's ice sculpture history spans over a century, tracing back to the first official Banff Winter Carnival in 1917, which featured ice sculptures, masquerade balls, and skijoring.",
        secretLetter: "Q"
    )
    
    static let hotSprings = Photo(
        id: "photo_hot_springs_marilyn_monroe",
        location: .hotSprings,
        photoName: "Marilyn Monroe at the Hot Springs",
        historicalNote: "When the Upper Hot Springs officially opened in 1886, guests arrived by horse-drawn carriage. The mineral waters, rich in sulphate, calcium, and magnesium, were promoted as a medical cure for ailments ranging from rheumatism to winter fatigue.",
        secretLetter: "H"
    )
    
    static let sulphurMountain = Photo(
        id: "photo_sulphur_mountain_banff_town",
        location: .sulphurMountain,
        photoName: "Town of Banff from Up High",
        historicalNote: "From Sulphur Mountain, Banff looks small beneath the vast sweep of the Bow Valley. Norman Sanson climbed this mountain more than 1,000 times to record weather observations, watching the town, trails, and weather patterns from above — exactly the kind of view needed to see what others missed.",
        secretLetter: "U"
    )
    
    static let lakeMinnewanka = Photo(
        id: "photo_lake_minnewanka_underwater_town",
        location: .lakeMinnewanka,
        photoName: "Minnewanka Landing",
        historicalNote: "Deep beneath the frozen surface lies Minnewanka Landing, once a booming 1880s summer resort town complete with hotels and wharves. It was swallowed by the lake in 1941 when a hydroelectric dam raised the water level by 64 feet.",
        secretLetter: "S"
    )
    
    static let tunnelMountain = Photo(
        id: "photo_tunnel_mountain_snowy_owl",
        location: .tunnelMountain,
        photoName: "Snowy Owl",
        historicalNote: "Snowy owls are powerful Arctic hunters, famous for their pale feathers and silent flight. They sometimes travel far south during winter irruptions, appearing like rare messengers from the North. Seeing one watch the trail near Tunnel Mountain feels less like chance and more like fate.",
        secretLetter: "A"
    )
    
    static let all: [Photo] = [
        museumExterior,
        bowFalls,
        caveAndBasin,
        banffSpringsHotel,
        downtownBanff,
        hotSprings,
        sulphurMountain,
        lakeMinnewanka,
        tunnelMountain
    ]
    
    static func photo(for location: Location) -> Photo? {
        all.first { $0.location == location }
    }
}
    
extension Photo {
    
    var cameraImageName: String {
        switch id {
        case Photo.museumExterior.id:
            return "camera_museum_exterior_footprint"
            
        case Photo.bowFalls.id:
            return "camera_bow_falls_douglas_fir"
            
        case Photo.caveAndBasin.id:
            return "camera_cave_and_basin_vent"
            
        case Photo.banffSpringsHotel.id:
            return "camera_banff_springs_ghost_bride"
            
        case Photo.downtownBanff.id:
            return "camera_downtown_bigfoot_ice_sculpture"
            
        case Photo.hotSprings.id:
            return "camera_hot_springs_marilyn"
            
        case Photo.sulphurMountain.id:
            return "camera_sulphur_mountain_banff_view"
            
        case Photo.lakeMinnewanka.id:
            return "camera_lake_minnewanka_underwater_town"
            
        case Photo.tunnelMountain.id:
            return "camera_tunnel_mountain_snowy_owl"
            
        default:
            return "camera_photo_placeholder"
        }
    }
}

