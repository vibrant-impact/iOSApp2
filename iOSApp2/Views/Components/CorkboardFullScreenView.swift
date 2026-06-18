//
//  CorkboardFullScreenView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-14.
//

import SwiftUI

struct CorkboardFullScreenView: View {
    
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    
    // MARK: - Location Hotspots
    
    private let locationHotspots: [CorkboardLocationHotspot] = [
        CorkboardLocationHotspot(
            id: "cave_and_basin",
            name: "Cave and Basin",
            location: .caveAndBasin,
            rect: CGRect(x: 167, y: 1234, width: 265, height: 264)
        ),
        CorkboardLocationHotspot(
            id: "hot_springs",
            name: "Upper Hot Springs",
            location: .hotSprings,
            rect: CGRect(x: 525, y: 1213, width: 249, height: 290)
        ),
        CorkboardLocationHotspot(
            id: "lake_minnewanka",
            name: "Lake Minnewanka",
            location: .lakeMinnewanka,
            rect: CGRect(x: 852, y: 1244, width: 257, height: 280)
        ),
        CorkboardLocationHotspot(
            id: "sulphur_mountain",
            name: "Sulphur Mountain",
            location: .sulphurMountain,
            rect: CGRect(x: 158, y: 1547, width: 256, height: 265)
        ),
        CorkboardLocationHotspot(
            id: "bow_falls",
            name: "Bow Falls",
            location: .bowFalls,
            rect: CGRect(x: 843, y: 1556, width: 252, height: 262)
        ),
        CorkboardLocationHotspot(
            id: "tunnel_mountain",
            name: "Tunnel Mountain",
            location: .tunnelMountain,
            rect: CGRect(x: 189, y: 1853, width: 268, height: 269)
        ),
        CorkboardLocationHotspot(
            id: "banff_springs_hotel",
            name: "Banff Springs Hotel",
            location: .banffSpringsHotel,
            rect: CGRect(x: 506, y: 1847, width: 276, height: 280)
        ),
        CorkboardLocationHotspot(
            id: "downtown_banff",
            name: "Downtown Banff",
            location: .downtownBanff,
            rect: CGRect(x: 843, y: 1858, width: 265, height: 268)
        )
    ]
    
    private var sceneHotspots: [SceneHotspot] {
        locationHotspots.map { marker in
            SceneHotspot(
                id: marker.id,
                name: marker.name,
                rect: marker.rect
            )
        }
    }
    
    
    // MARK: - Letter Overlays
    
    private let letterOverlays: [CorkboardLetterOverlay] = [
        CorkboardLetterOverlay(
            id: "letter_a_museum_exterior",
            imageName: "corkboard_letter_a_1",
            photo: .museumExterior,
            rect: CGRect(x: 128, y: 1025, width: 121, height: 156)
        ),
        CorkboardLetterOverlay(
            id: "letter_s_bow_falls",
            imageName: "corkboard_letter_s_1",
            photo: .bowFalls,
            rect: CGRect(x: 245, y: 1059, width: 117, height: 152)
        ),
        CorkboardLetterOverlay(
            id: "letter_t_cave_and_basin",
            imageName: "corkboard_letter_t",
            photo: .caveAndBasin,
            rect: CGRect(x: 358, y: 1017, width: 108, height: 146)
        ),
        CorkboardLetterOverlay(
            id: "letter_c_banff_springs_hotel",
            imageName: "corkboard_letter_c",
            photo: .banffSpringsHotel,
            rect: CGRect(x: 465, y: 1045, width: 112, height: 154)
        ),
        CorkboardLetterOverlay(
            id: "letter_q_downtown_banff",
            imageName: "corkboard_letter_q",
            photo: .downtownBanff,
            rect: CGRect(x: 576, y: 1057, width: 124, height: 148)
        ),
        CorkboardLetterOverlay(
            id: "letter_h_hot_springs",
            imageName: "corkboard_letter_h",
            photo: .hotSprings,
            rect: CGRect(x: 663, y: 1013, width: 142, height: 168)
        ),
        CorkboardLetterOverlay(
            id: "letter_u_sulphur_mountain",
            imageName: "corkboard_letter_u",
            photo: .sulphurMountain,
            rect: CGRect(x: 794, y: 1028, width: 139, height: 180)
        ),
        CorkboardLetterOverlay(
            id: "letter_s_lake_minnewanka",
            imageName: "corkboard_letter_s_2",
            photo: .lakeMinnewanka,
            rect: CGRect(x: 907, y: 1065, width: 126, height: 154)
        ),
        CorkboardLetterOverlay(
            id: "letter_a_tunnel_mountain",
            imageName: "corkboard_letter_a_2",
            photo: .tunnelMountain,
            rect: CGRect(x: 986, y: 1023, width: 143, height: 175)
        )
    ]
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        letterOverlays
            .filter { gameState.hasPhoto($0.photo) }
            .map { letter in
                SceneOverlayObject(
                    id: letter.id,
                    imageName: letter.imageName,
                    rect: letter.rect
                )
            }
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "corkboard_base",
                canvasSize: canvasSize,
                hotspots: sceneHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "The Curator's Corkboard",
                locationSubtitle: "Save the museum with the story of the century",
                showsBagButton: false,
                showsJournalButton: false,
                onBagTapped: {
                    showingInventory = false
                },
                onJournalTapped: {
                    showingJournal = false
                }
            )
            closeButton
        }
    }
    
    
    // MARK: - Close Button
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    SoundManager.shared.play(.close, volume: 0.45)
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(.white.opacity(0.92))
                        .shadow(color: .black.opacity(0.55), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 18)
                .padding(.top, 18)
            }
            
            Spacer()
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        guard let marker = locationHotspots.first(where: { $0.id == hotspot.id }) else {
            return
        }
        SoundManager.shared.play(.locationTravel, volume: 0.45)
        gameState.currentLocation = marker.location
        dismiss()
    }
}


// MARK: - Supporting Models

private struct CorkboardLocationHotspot {
    let id: String
    let name: String
    let location: Location
    let rect: CGRect
}

private struct CorkboardLetterOverlay {
    let id: String
    let imageName: String
    let photo: Photo
    let rect: CGRect
}


// MARK: - Preview

#Preview {
    CorkboardFullScreenView()
        .environmentObject(GameState())
}
