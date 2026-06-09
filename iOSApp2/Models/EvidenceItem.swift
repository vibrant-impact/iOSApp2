//
//  EvidenceItem.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

/// Represents one piece of evidence the player can collect during the game.
///
/// Evidence items are different from inventory items:
/// - Evidence is used to prove story progress.
/// - Inventory items are tools or objects the player can use later.

struct EvidenceItem: Identifiable, Equatable {
    
    /// A unique string used to identify this evidence item.
    ///
    /// This is what `GameState` stores when evidence is collected.
    /// Example:
    /// `"photo_cave_sign"`
    let id: String
    
    /// The display name shown to the player.
    ///
    /// Example:
    /// `"Photograph: Cave and Basin Sign"`
    let name: String
    
    /// A longer explanation of what the evidence is and why it matters.
    ///
    /// This text appears in evidence lists, alerts, or summary screens.
    let description: String
    
    /// The id of the story lead/location where this evidence belongs.
    ///
    /// This is optional because some evidence could belong to no specific lead
    /// or could be used as general game evidence.
    ///
    /// Example:
    /// `"cave_and_basin"`
    let sourceLeadID: String?
    
    /// The SF Symbol name used when displaying this evidence in the UI.
    ///
    /// Example:
    /// `"camera.fill"`
    let systemImage: String
}


// MARK: - Evidence Library

extension EvidenceItem {
    
    /// Creates a generic placeholder evidence item for a story lead.
    ///
    /// This is useful when a lead needs a basic evidence entry before
    /// specific custom evidence has been created.
    ///
    /// - Parameter lead: The story lead this placeholder evidence belongs to.
    /// - Returns: A new generic `EvidenceItem` connected to the given lead.
    static func placeholderEvidence(for lead: StoryLead) -> EvidenceItem {
        EvidenceItem(
            id: "evidence_\(lead.id)",
            name: "Field Notes: \(lead.title)",
            description: "Photos, notes, and observations gathered at \(lead.title). The museum curator may be able to connect this to the larger mystery.",
            sourceLeadID: lead.id,
            systemImage: "doc.text.image.fill"
        )
    }
    
    
    // MARK: - Cave and Basin Evidence
    
    /// Photograph of the Cave and Basin sign.
    ///
    /// This connects the location to Banff's official protected-area history.
    static let caveSignPhoto = EvidenceItem(
        id: "photo_cave_sign",
        name: "Photograph: Cave and Basin Sign",
        description: "A photograph of the historic sign at Cave and Basin. It connects Banff’s official beginning to the mineral springs.",
        sourceLeadID: "cave_and_basin",
        systemImage: "camera.fill"
    )
    
    /// Cloth sample containing gold-colored dust from the glowing cave crack.
    ///
    /// This is one of the strongest early clues that the Lost Lemon Mine legend
    /// may have a real physical connection to Banff.
    static let goldDustedCloth = EvidenceItem(
        id: "gold_dusted_cloth",
        name: "Gold-Dusted Cloth",
        description: "The old towel now glitters with fine gold-colored dust collected from a glowing crack in the wet stone.",
        sourceLeadID: "cave_and_basin",
        systemImage: "sparkles"
    )
    
    /// Sealed oilcloth fragment recovered from the hot pool.
    ///
    /// This item is important because it hints at a protected message, map,
    /// or object hidden inside waterproof material.
    static let sealedOilclothFragment = EvidenceItem(
        id: "sealed_oilcloth_fragment",
        name: "Sealed Oilcloth Fragment",
        description: "A dark, water-worn fragment retrieved from the bottom of the hot pool. Something appears to be sealed inside the old oilcloth.",
        sourceLeadID: "cave_and_basin",
        systemImage: "map.fill"
    )
    
    
    // MARK: - Bow Falls Evidence
    
    /// Photograph of the Parks maintenance tag attached to the long-handled net.
    ///
    /// This proves the net belongs to official maintenance equipment and helps
    /// explain why it can be used safely to retrieve objects from water.
    static let parksNetTagPhoto = EvidenceItem(
        id: "photo_parks_net_tag",
        name: "Photograph: Parks Net Tag",
        description: "A photo of a worn Parks maintenance tag attached to a long-handled net near Bow Falls.",
        sourceLeadID: "bow_falls",
        systemImage: "camera.fill"
    )
    
    /// Old survey marker found near Bow Falls.
    ///
    /// This connects Bow Falls to old mapping, routes, and possible mine-related
    /// survey activity.
    static let oldSurveyMarker = EvidenceItem(
        id: "old_survey_marker",
        name: "Old Survey Marker",
        description: "A weathered wooden survey marker uncovered from hard-packed snow near Bow Falls.",
        sourceLeadID: "bow_falls",
        systemImage: "mappin.and.ellipse"
    )
    
    
    // MARK: - Banff Springs Hotel Evidence
    
    /// Photograph of an old guest ledger page.
    ///
    /// The ledger references a strange figure beyond the service paths,
    /// connecting the hotel lead to the Bigfoot mystery.
    static let guestLedgerPage = EvidenceItem(
        id: "photo_guest_ledger",
        name: "Photograph: Guest Ledger Page",
        description: "A photo of an old hotel ledger page mentioning a huge figure seen beyond the service paths.",
        sourceLeadID: "banff_springs_hotel",
        systemImage: "book.closed.fill"
    )
    
    /// Photograph of an unusually large footprint near the hotel service path.
    ///
    /// This strengthens the connection between hotel sightings and the larger
    /// creature/Bigfoot storyline.
    static let servicePathFootprint = EvidenceItem(
        id: "photo_service_path_footprint",
        name: "Photograph: Service Path Footprint",
        description: "A photo of an unusually large footprint near the hotel service path.",
        sourceLeadID: "banff_springs_hotel",
        systemImage: "pawprint.fill"
    )
    
    
    // MARK: - Hot Springs Evidence
    
    /// Token marked with a mineral spring symbol.
    ///
    /// This clue ties the hot springs to the larger symbol pattern found across
    /// Banff locations.
    static let mineralSpringToken = EvidenceItem(
        id: "mineral_spring_token",
        name: "Mineral Spring Token",
        description: "A small token marked with a spring symbol and mineral stains.",
        sourceLeadID: "hot_springs",
        systemImage: "circle.hexagongrid.fill"
    )
    
    
    // MARK: - Sulphur Mountain Evidence
    
    /// Route marker photographed from the Sulphur Mountain ridge.
    ///
    /// Its symbol resembles the mark on the oilcloth, suggesting that the
    /// oilcloth may point toward a mountain route.
    static let ridgeRouteMarker = EvidenceItem(
        id: "ridge_route_marker",
        name: "Ridge Route Marker",
        description: "A route marker photographed from the Sulphur Mountain ridge. Its symbol resembles the mark on the oilcloth.",
        sourceLeadID: "sulphur_mountain_gondola",
        systemImage: "mountain.2.fill"
    )
    
    
    // MARK: - Tunnel Mountain Evidence
    
    /// Photograph of a large track on Tunnel Mountain.
    ///
    /// This clue helps connect the Bigfoot trail evidence to the final mystery.
    static let tunnelMountainTrack = EvidenceItem(
        id: "tunnel_mountain_track",
        name: "Photograph: Tunnel Mountain Track",
        description: "A clear photo of a large track pressed deep into the trail mud and snow.",
        sourceLeadID: "tunnel_mountain",
        systemImage: "shoeprints.fill"
    )
}
