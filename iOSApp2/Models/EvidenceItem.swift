//
//  EvidenceItem.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

struct EvidenceItem: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let sourceLeadID: String?
    let systemImage: String
}

extension EvidenceItem {
    static func placeholderEvidence(for lead: StoryLead) -> EvidenceItem {
        EvidenceItem(
            id: "evidence_\(lead.id)",
            name: "Field Notes: \(lead.title)",
            description: "Photos, notes, and observations gathered at \(lead.title). The museum curator may be able to connect this to the larger mystery.",
            sourceLeadID: lead.id,
            systemImage: "doc.text.image.fill"
        )
    }
    
    static let caveSignPhoto = EvidenceItem(
        id: "photo_cave_sign",
        name: "Photograph: Cave and Basin Sign",
        description: "A photograph of the historic sign at Cave and Basin. It connects Banff’s official beginning to the mineral springs.",
        sourceLeadID: "cave_and_basin",
        systemImage: "camera.fill"
    )
    
    static let goldDustedCloth = EvidenceItem(
        id: "gold_dusted_cloth",
        name: "Gold-Dusted Cloth",
        description: "The old towel now glitters with fine gold-colored dust collected from a glowing crack in the wet stone.",
        sourceLeadID: "cave_and_basin",
        systemImage: "sparkles"
    )
    
    static let sealedOilclothFragment = EvidenceItem(
        id: "sealed_oilcloth_fragment",
        name: "Sealed Oilcloth Fragment",
        description: "A dark, water-worn fragment retrieved from the bottom of the hot pool. Something appears to be sealed inside the old oilcloth.",
        sourceLeadID: "cave_and_basin",
        systemImage: "map.fill"
    )
    
    static let parksNetTagPhoto = EvidenceItem(
        id: "photo_parks_net_tag",
        name: "Photograph: Parks Net Tag",
        description: "A photo of a worn Parks maintenance tag attached to a long-handled net near Bow Falls.",
        sourceLeadID: "bow_falls",
        systemImage: "camera.fill"
    )

    static let oldSurveyMarker = EvidenceItem(
        id: "old_survey_marker",
        name: "Old Survey Marker",
        description: "A weathered wooden survey marker uncovered from hard-packed snow near Bow Falls.",
        sourceLeadID: "bow_falls",
        systemImage: "mappin.and.ellipse"
    )

    static let guestLedgerPage = EvidenceItem(
        id: "photo_guest_ledger",
        name: "Photograph: Guest Ledger Page",
        description: "A photo of an old hotel ledger page mentioning a huge figure seen beyond the service paths.",
        sourceLeadID: "banff_springs_hotel",
        systemImage: "book.closed.fill"
    )

    static let servicePathFootprint = EvidenceItem(
        id: "photo_service_path_footprint",
        name: "Photograph: Service Path Footprint",
        description: "A photo of an unusually large footprint near the hotel service path.",
        sourceLeadID: "banff_springs_hotel",
        systemImage: "pawprint.fill"
    )

    static let mineralSpringToken = EvidenceItem(
        id: "mineral_spring_token",
        name: "Mineral Spring Token",
        description: "A small token marked with a spring symbol and mineral stains.",
        sourceLeadID: "hot_springs",
        systemImage: "circle.hexagongrid.fill"
    )

    static let ridgeRouteMarker = EvidenceItem(
        id: "ridge_route_marker",
        name: "Ridge Route Marker",
        description: "A route marker photographed from the Sulphur Mountain ridge. Its symbol resembles the mark on the oilcloth.",
        sourceLeadID: "sulphur_mountain_gondola",
        systemImage: "mountain.2.fill"
    )

    static let tunnelMountainTrack = EvidenceItem(
        id: "tunnel_mountain_track",
        name: "Photograph: Tunnel Mountain Track",
        description: "A clear photo of a large track pressed deep into the trail mud and snow.",
        sourceLeadID: "tunnel_mountain",
        systemImage: "shoeprints.fill"
    )
}
