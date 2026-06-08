//
//  StoryLead.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

enum StoryLeadPhase: Int, CaseIterable {
    case first = 1
    case second = 2
    case final = 3
    
    var title: String {
        switch self {
        case .first:
            return "First Leads"
        case .second:
            return "Deeper Pattern"
        case .final:
            return "Final Trail"
        }
    }
    
    var lockedMessage: String {
        switch self {
        case .first:
            return ""
        case .second:
            return "Complete all first leads and recover the submerged clue from Cave and Basin."
        case .final:
            return "Complete the deeper pattern to unlock."
        }
    }
}

struct StoryLead: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let publicMystery: String
    let curatorNote: String
    let location: Location
    let phase: StoryLeadPhase
    let systemImage: String
}

extension StoryLead {
    static let all: [StoryLead] = [
        StoryLead(
            id: "cave_and_basin",
            title: "Cave and Basin",
            subtitle: "Steam, stone, and old beginnings.",
            publicMystery: "Banff’s origins are tied to mineral springs, old claims, and strange stories of warm caves in winter.",
            curatorNote: "Start where Banff began. Places of origin have a way of remembering more than people do.",
            location: .caveAndBasin,
            phase: .first,
            systemImage: "flame.fill"
        ),
        
        StoryLead(
            id: "bow_falls",
            title: "Bow Falls",
            subtitle: "Winter thunder beneath the ice.",
            publicMystery: "Visitors sometimes report strange calls near the falls when the river is locked in snow and shadow.",
            curatorNote: "Most people hear water. Listen for what answers it.",
            location: .bowFalls,
            phase: .first,
            systemImage: "water.waves"
        ),
        
        StoryLead(
            id: "banff_springs_hotel",
            title: "Banff Springs Hotel",
            subtitle: "Ghosts in the grand old halls.",
            publicMystery: "The hotel has no shortage of ghost stories, but one old account mentions a huge figure outside the service paths.",
            curatorNote: "Ghost stories are useful. They let witnesses tell the truth without being believed.",
            location: .banffSpringsHotel,
            phase: .first,
            systemImage: "building.columns.fill"
        ),
        
        StoryLead(
            id: "hot_springs",
            title: "Hot Springs",
            subtitle: "Warm refuge in a frozen world.",
            publicMystery: "Steam can hide many things. Some winter sightings mention movement near the rocks after closing.",
            curatorNote: "Every creature seeks warmth. Even legends.",
            location: .hotSprings,
            phase: .second,
            systemImage: "thermometer.sun.fill"
        ),
        
        StoryLead(
            id: "sulphur_mountain_gondola",
            title: "Sulphur Mountain Gondola",
            subtitle: "A view from above the pattern.",
            publicMystery: "From the ridge, old routes and animal paths sometimes appear in ways they never do from below.",
            curatorNote: "When the pieces refuse to connect, climb higher.",
            location: .sulphurMountainGondola,
            phase: .second,
            systemImage: "mountain.2.fill"
        ),
        
        StoryLead(
            id: "tunnel_mountain",
            title: "Tunnel Mountain",
            subtitle: "Tracks between town and timber.",
            publicMystery: "Large winter tracks have been reported near the trails, usually dismissed as bears, boots, or melting snow.",
            curatorNote: "A trail is a sentence written by something that passed through.",
            location: .tunnelMountain,
            phase: .second,
            systemImage: "pawprint.fill"
        ),
        
        StoryLead(
            id: "lake_minnewanka",
            title: "Lake Minnewanka",
            subtitle: "Where the last clues gather.",
            publicMystery: "Old stories near the lake speak of vanished prospectors, strange lights, and paths that do not stay found.",
            curatorNote: "If the mine exists, the route bends toward Minnewanka. Be careful. Some stories protect themselves.",
            location: .lakeMinnewanka,
            phase: .final,
            systemImage: "snowflake"
        )
    ]
}
