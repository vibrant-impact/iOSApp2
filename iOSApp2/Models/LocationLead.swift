//
//  LocationLead.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-13.
//

import Foundation

enum LocationLeadPhase: Int, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
    case final = 4
    
    var title: String {
        switch self {
        case .first:
            return "The Foundations"
        case .second:
            return "The Ascent"
        case .third:
            return "The Deep Wilderness"
        case .final:
            return "The Final Trail"
        }
    }
    
    var lockedMessage: String {
        switch self {
        case .first:
            return "" // Always unlocked
        case .second:
            return "Find usable items from the first three leads."
        case .third:
            return "Discover the observatory's secrets and retrieve the crowbar."
        case .final:
            return "Recover the woodcutter's axe from the ice."
        }
    }
}


// MARK: - Location Lead Model

struct LocationLead: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let publicMystery: String
    let curatorNote: String
    let location: Location
    let phase: LocationLeadPhase
    let systemImage: String
}


// MARK: - Location Lead Library

extension LocationLead {
    
    static let all: [LocationLead] = [
        
        // MARK: First Phase
        
        LocationLead(
            id: "banff_springs_hotel",
            title: "Banff Springs Hotel",
            subtitle: "Ghosts in the grand old halls.",
            publicMystery: "The hotel has no shortage of ghost stories, but one old tag points somewhere more ordinary — and more useful.",
            curatorNote: "Ghost stories are useful. They let witnesses tell the truth without being believed.",
            location: .banffSpringsHotel,
            phase: .first,
            systemImage: "building.columns.fill"
        ),
        
        LocationLead(
            id: "cave_and_basin",
            title: "Cave and Basin",
            subtitle: "Steam, stone, and old beginnings.",
            publicMystery: "Banff's origins are tied to mineral springs, old claims, and strange stories of warm caves in winter.",
            curatorNote: "Start where Banff began. Places of origin have a way of remembering more than people do.",
            location: .caveAndBasin,
            phase: .first,
            systemImage: "flame.fill"
        ),
        
        LocationLead(
            id: "bow_falls",
            title: "Bow Falls",
            subtitle: "Winter thunder beneath the ice.",
            publicMystery: "The frozen falls hide old routes, strong wood, and something buried beneath the snow.",
            curatorNote: "Most people hear water. Listen for what answers it.",
            location: .bowFalls,
            phase: .first,
            systemImage: "water.waves"
        ),
        
        // MARK: Second Phase
        
        LocationLead(
            id: "hot_springs",
            title: "Upper Hot Springs",
            subtitle: "Warm refuge in a frozen world.",
            publicMystery: "The steaming pools hide more than just warmth. Signs point to a researcher interested in local tokens.",
            curatorNote: "Some say the hot springs hold the secrets of the earth. Others just want a good soak.",
            location: .hotSprings,
            phase: .first,
            systemImage: "thermometer.sun.fill"
        ),
        
        LocationLead(
            id: "downtown_banff",
            title: "Downtown Banff",
            subtitle: "A warm cafe and a local researcher.",
            publicMystery: "A lead from the hot springs points to the Snowy Owl Cafe, where a researcher may know more about the observatory.",
            curatorNote: "A story often turns on the smallest exchange. Seek out who knows the town's older secrets.",
            location: .downtownBanff,
            phase: .first,
            systemImage: "cup.and.saucer.fill"
        ),
        
        LocationLead(
            id: "sulphur_mountain",
            title: "Sulphur Mountain Summit",
            subtitle: "A view from above the pattern.",
            publicMystery: "From the summit, the observatory beckons. Its door may be iced shut, but perhaps a warm clue awaits.",
            curatorNote: "When the pieces refuse to connect, climb higher.",
            location: .sulphurMountain,
            phase: .first,
            systemImage: "mountain.2.fill"
        ),
        
        
        // MARK: Third Phase (Observatory is unlocked via Sulphur Mountain, not corkboard, but listed here for completeness)
        
        LocationLead(
            id: "observatory",
            title: "Observatory",
            subtitle: "Records from the summit.",
            publicMystery: "Dusty logbooks and locked cabinets may contain clues about who, or what, watches the wilderness.",
            curatorNote: "The highest points often hold the oldest truths.",
            location: .observatory,
            phase: .first,
            systemImage: "telescope.fill"
        ),
        
        
        // MARK: Fourth Phase (Lake Minnewanka)
        
        LocationLead(
            id: "lake_minnewanka",
            title: "Lake Minnewanka",
            subtitle: "A drowned town beneath the ice.",
            publicMystery: "A frozen crate near the lake may contain something strong enough for the final trail.",
            curatorNote: "Some places are buried by water. Some by silence.",
            location: .lakeMinnewanka,
            phase: .first,
            systemImage: "snowflake"
        ),
        
        
        // MARK: Final Phase
        
        LocationLead(
            id: "tunnel_mountain",
            title: "Tunnel Mountain",
            subtitle: "Tracks between town and timber.",
            publicMystery: "Large winter tracks have been reported near the trails, usually dismissed as bears, boots, or melting snow.",
            curatorNote: "A trail is a sentence written by something that passed through.",
            location: .tunnelMountain,
            phase: .first,
            systemImage: "pawprint.fill"
        )
    ]
}
