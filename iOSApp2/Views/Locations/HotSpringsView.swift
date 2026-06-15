//
//  HotSpringsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct HotSpringsView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: HotSpringsZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "marilyn_monroe_picture",
            name: "Marilyn Monroe Picture",
            rect: CGRect(x: 839, y: 1416, width: 382, height: 538)
        ),
        SceneHotspot(
            id: "keys", // The actual key hotspot
            name: "Keys on Board",
            rect: CGRect(x: 1079, y: 2033, width: 186, height: 199)
        ),
        SceneHotspot(
            id: "lodge",
            name: "Hot Springs Lodge",
            rect: CGRect(x: 664, y: 840, width: 626, height: 424)
        ),
        SceneHotspot(
            id: "map_table",
            name: "Table with Map",
            rect: CGRect(x: 1010, y: 2302, width: 280, height: 233)
        ),
        SceneHotspot(
            id: "shed",
            name: "Shed",
            rect: CGRect(x: 0, y: 1585, width: 211, height: 317)
        ),
        SceneHotspot(
            id: "hot_pool",
            name: "Hot Spring Pool",
            rect: CGRect(x: 263, y: 1262, width: 583, height: 292)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "keys":
                return gameState.hasTradedVintageBrassToken && !gameState.hasCollectedObservatoryLockerKey
            case "map_table":
                return !gameState.hasFoundCafeLead
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        // Overlay for when keys are taken
        if gameState.hasCollectedObservatoryLockerKey {
            overlays.append(
                SceneOverlayObject(
                    id: "key_gone",
                    imageName: "hot_springs_key_gone_overlay",
                    rect: CGRect(x: 1119, y: 2062, width: 76, height: 157)
                )
            )
        }
        
        if gameState.hasFoundCafeLead {
            overlays.append(
                SceneOverlayObject(
                    id: "cafe_lead_gone",
                    imageName: "hot_springs_cafe_lead_gone_overlay",
                    rect: CGRect(x: 970, y: 2356, width: 218, height: 162)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "hot_springs_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Upper Hot Springs",
                locationSubtitle: "Warm refuge in a frozen world",
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
        case "marilyn_monroe_picture":
            activePhoto = Photo.hotSprings
            
        case "keys":
            activeZoomOverlay = .keysAvailable
            
        case "map_table":
            activeZoomOverlay = .mapTable
            
        case "lodge":
            showAlert(
                title: "Hot Springs Lodge",
                message: "The lodge is quiet, but the windows glow with mountain warmth."
            )
            
        case "shed":
            showAlert(
                title: "Small Shed",
                message: "A small shed beside the hot springs—practical as ever, built for chores and sore hands."
            )
            
        case "hot_pool":
            showAlert(
                title: "Hot Spring Pool",
                message: "Steam rolls over the mineral water. Even in deep winter, the pool refuses to freeze."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: HotSpringsZoomOverlay) -> some View {
        switch overlay {
        case .mapTable:
            HotspotZoomOverlay(
                title: "Map on the Table",
                imageName: "zoom_hot_springs_cafe_lead",
                description: """
                A worn map and research notes lie on the table. The researcher could be helpful to chat with. 

                Scribblings on a napkin point toward the 'Snowy Owl Cafe' in downtown Banff.
                """,
                primaryButtonTitle: "Take Cafe Lead",
                onPrimaryAction: {
                    if !gameState.hasFoundCafeLead {
                        gameState.collectInventoryItem(.cafeLead)
                    }
                    activeZoomOverlay = nil
                    collectedItemOverlay = .cafeLead
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .keysAvailable:
            HotspotZoomOverlay(
                title: "Keys on Board",
                imageName: "zoom_hot_springs_keys",
                description: "There it is, the green key that the researcher promised. It's onward to the Sulphur Mountain Observatory from here.",
                primaryButtonTitle: "Take Observatory Key",
                onPrimaryAction: {
                    gameState.collectInventoryItem(.observatoryLockerKey)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .observatoryLockerKey
                },
                onClose: {
                    activeZoomOverlay = nil
                }
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

private enum HotSpringsZoomOverlay: Identifiable {
    case mapTable
    case keysAvailable
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    HotSpringsView()
        .environmentObject(GameState())
}
