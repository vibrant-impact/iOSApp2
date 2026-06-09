//
//  StoryLead.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

/// Represents the stage of the story that a lead belongs to.
///
/// The game does not reveal every location immediately.
/// Instead, leads are grouped into phases so the mystery can unfold gradually:
/// - first leads are available early
/// - second leads unlock after key progress
/// - final leads unlock near the end of the game
///
/// The raw `Int` values can be useful for sorting or comparing phases.
enum StoryLeadPhase: Int, CaseIterable {
    
    /// The first group of leads available to the player.
    ///
    /// These are the starting investigation locations after the player enters
    /// the museum and checks the curator's corkboard.
    case first = 1
    
    /// The second group of leads.
    ///
    /// These become available after the player completes important early
    /// investigation steps.
    case second = 2
    
    /// The final group of leads.
    ///
    /// These are late-game leads that guide the player toward the ending.
    case final = 3
    
    
    // MARK: - Display Title
    
    /// A player-friendly title for each story phase.
    ///
    /// This can be shown on the corkboard or lead selection screen to organize
    /// the investigation.
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
    
    
    // MARK: - Locked Message
    
    /// The message shown when a phase is not unlocked yet.
    ///
    /// The first phase has no locked message because it is available from
    /// the beginning of the main investigation.
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


// MARK: - Story Lead Model

/// Represents one investigation lead on the curator's corkboard.
///
/// A `StoryLead` is not the same as a full scene.
/// Instead, it stores the information needed to show a lead to the player and
/// send them to the correct `Location`.
///
/// Each lead includes:
/// - a title
/// - a short subtitle
/// - a public mystery description
/// - a private curator note
/// - the location it opens
/// - the story phase it belongs to
/// - an SF Symbol for display
struct StoryLead: Identifiable, Equatable {
    
    /// A unique string used to identify this story lead.
    ///
    /// This id is used by evidence, progress tracking, and lead completion logic.
    ///
    /// Example:
    /// `"cave_and_basin"`
    let id: String
    
    /// The main title shown on the lead card.
    ///
    /// Example:
    /// `"Cave and Basin"`
    let title: String
    
    /// A short atmospheric subtitle for the lead.
    ///
    /// This gives the player a quick sense of the location's mood or mystery.
    let subtitle: String
    
    /// The public-facing mystery connected to this location.
    ///
    /// This text sounds like something a visitor, tourist, or local legend might
    /// mention. It explains why the location is suspicious or interesting.
    let publicMystery: String
    
    /// A private note from the museum curator.
    ///
    /// This gives the player a more mysterious hint about what to investigate.
    let curatorNote: String
    
    /// The game location that this lead opens.
    ///
    /// When the player selects this lead, the app can change
    /// `GameState.currentLocation` to this value.
    let location: Location
    
    /// The story phase this lead belongs to.
    ///
    /// This controls when the lead should become available.
    let phase: StoryLeadPhase
    
    /// The SF Symbol name used to visually represent this lead in the UI.
    ///
    /// Example:
    /// `"flame.fill"`
    let systemImage: String
}


// MARK: - Story Lead Library

extension StoryLead {
    
    /// A complete list of all story leads used in the game.
    ///
    /// This array is used by the corkboard or lead selection view to display
    /// investigation options to the player.
    static let all: [StoryLead] = [
        
        // MARK: First Leads
        
        /// First lead: Cave and Basin.
        ///
        /// This lead sends the player to the Cave and Basin location and begins
        /// the mineral spring part of the mystery.
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
        
        /// First lead: Bow Falls.
        ///
        /// This lead sends the player to Bow Falls, where water, snow, sound,
        /// and survey clues become important.
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
        
        /// First lead: Banff Springs Hotel.
        ///
        /// This lead connects the investigation to ghost stories, hotel records,
        /// and sightings near the service paths.
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
        
        
        // MARK: Second Leads
        
        /// Second lead: Hot Springs.
        ///
        /// This lead expands the mineral spring storyline and suggests that warm
        /// places may attract or protect hidden creatures.
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
        
        /// Second lead: Sulphur Mountain Gondola.
        ///
        /// This lead gives the player a higher viewpoint so they can begin
        /// connecting the pattern between locations.
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
        
        /// Second lead: Tunnel Mountain.
        ///
        /// This lead focuses on strange tracks and trail evidence between town
        /// and the forest.
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
        
        
        // MARK: Final Leads
        
        /// Final lead: Lake Minnewanka.
        ///
        /// This late-game lead points toward the final route, vanished prospectors,
        /// and the possibility that the Lost Lemon Mine legend is connected to
        /// the wider Banff mystery.
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
