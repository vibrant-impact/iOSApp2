//
//  DowntownBanffView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-12.
//

import SwiftUI

struct DowntownBanffView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: DowntownZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "cafe",
            name: "Snowy Owl Cafe",
            rect: CGRect(x: 0, y: 1437, width: 341, height: 465)
        ),
        SceneHotspot(
            id: "bigfoot_ice_sculpture",
            name: "Bigfoot Ice Sculpture",
            rect: CGRect(x: 697, y: 1504, width: 443, height: 488)
        ),
        SceneHotspot(
            id: "horse_buggy",
            name: "Horse Buggy",
            rect: CGRect(x: 215, y: 1970, width: 330, height: 376)
        ),
        SceneHotspot(
            id: "town_hall",
            name: "Town Hall",
            rect: CGRect(x: 935, y: 856, width: 355, height: 662)
        ),
        SceneHotspot(
            id: "cascade_mountain",
            name: "Cascade Mountain",
            rect: CGRect(x: 419, y: 391, width: 605, height: 725)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        []
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "downtown_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Downtown Banff",
                locationSubtitle: "A warm cafe and a local researcher",
                onBagTapped: {
                    showingInventory = true
                },
                onJournalTapped: {
                    showingJournal = true
                }
            )
            
            returnButton
            
            if let activeZoomOverlay {
                zoomOverlay(for: activeZoomOverlay)
            }
            
            if let collectedItemOverlay {
                ItemCollectedOverlay(item: collectedItemOverlay) {
                    self.collectedItemOverlay = nil
                }
            }
        }
        
        .onAppear {
            SoundManager.shared.stopAllAmbience()
            SoundManager.shared.playAmbience(.townStreet, volume: 1.0)
        }
        
        .onDisappear {
            SoundManager.shared.play(.locationTravel, volume: 0.45)
            SoundManager.shared.stopAmbience(.townStreet)
        }
        
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        .sheet(isPresented: $showingJournal) {
            JournalView()
                .environmentObject(gameState)
                .presentationDetents([.medium, .large])
        }
        
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(item: $activePhoto) { photo in
            FakeCameraView(
                photo: photo,
                alreadyCaptured: gameState.hasPhoto(photo),
                onCapture: { capturedPhoto in
                    gameState.capturePhoto(capturedPhoto)
                }
            )
        }
    }
    
    
    // MARK: - Return Button
    
    private var returnButton: some View {
        VStack {
            Spacer()
            
            Button {
                gameState.currentLocation = .museumInterior
            } label: {
                Label("Return to Museum", systemImage: "arrow.uturn.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "cafe":
            if !gameState.hasFoundCafeLead {
                activeZoomOverlay = .cafeNoLead
            } else if !gameState.hasInventoryItem(.vintageBrassToken) {
                activeZoomOverlay = .cafeNoToken
            } else if !gameState.hasTradedVintageBrassToken {
                activeZoomOverlay = .cafeTradeToken
            } else {
                activeZoomOverlay = .cafeAfterTrade
            }
            
        case "bigfoot_ice_sculpture":
            activePhoto = Photo.downtownBanff
            
        case "horse_buggy":
            showAlert(
                title: "Horse Buggy",
                message: "The buggy looks decorative now, but Banff winters were once crossed one frozen street at a time."
            )
            
        case "town_hall":
            showAlert(
                title: "Town Hall",
                message: "The town hall stands steady under the mountain shadows. Official records rarely mention legends unless they cause paperwork."
            )
            
        case "cascade_mountain":
            showAlert(
                title: "Cascade Mountain",
                message: "Cascade Mountain rises over town like a frozen wall. Somewhere beyond the familiar streets, the wilderness begins making its own rules."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: DowntownZoomOverlay) -> some View {
        switch overlay {
        case .cafeNoLead:
            HotspotZoomOverlay(
                title: "Snowy Owl Cafe",
                imageName: "zoom_downtown_cafe_interior", // Assumes you have this zoom image.
                description: "The cafe is warm and busy. A researcher looks preoccupied, perhaps waiting for someone.",
                primaryButtonTitle: "Close",
                onPrimaryAction: { activeZoomOverlay = nil },
                onClose: { activeZoomOverlay = nil }
            )
            
        case .cafeNoToken:
            HotspotZoomOverlay(
                title: "Snowy Owl Cafe",
                imageName: "zoom_downtown_cafe_interior",
                description: "The researcher looks up as you approach. 'Another token?' they sigh, 'Unless it's connected to the old Banff Spring records, I'm afraid I haven't the time.'",
                primaryButtonTitle: "Close",
                onPrimaryAction: { activeZoomOverlay = nil },
                onClose: { activeZoomOverlay = nil }
            )
            
        case .cafeTradeToken:
            HotspotZoomOverlay(
                title: "Snowy Owl Cafe",
                imageName: "zoom_downtown_cafe_interior",
                description: """
                The researcher's eyes light up at the sight of the vintage brass token.

                'In exchange for this token, I can help you. You should investigate the Sulphur Mountain Observatory. Take the observatory locker key that I left at the hot springs. It's the only green key on the board.' 
                """,
                primaryButtonTitle: "Trade Token",
                onPrimaryAction: {
                    gameState.hasTradedVintageBrassToken = true
                    gameState.useInventoryItem(.vintageBrassToken)
                    gameState.collectInventoryItem(.observatoryStoryLead)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .observatoryStoryLead
                },
                onClose: { activeZoomOverlay = nil }
            )
            
        case .cafeAfterTrade:
            HotspotZoomOverlay(
                title: "Snowy Owl Cafe",
                imageName: "zoom_downtown_cafe_interior",
                description: "The researcher is now absorbed in studying the token, muttering about early park archives. The lead to the observatory key is safe in your journal.",
                primaryButtonTitle: "Close",
                onPrimaryAction: { activeZoomOverlay = nil },
                onClose: { activeZoomOverlay = nil }
            )
        }
    }
    
    
    // MARK: - Alerts
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Zoom Overlay Types

private enum DowntownZoomOverlay: Identifiable {
    case cafeNoLead
    case cafeNoToken
    case cafeTradeToken
    case cafeAfterTrade
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    DowntownBanffView()
        .environmentObject(GameState())
}
