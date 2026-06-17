//
//  CaveAndBasinView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct CaveAndBasinView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: CaveAndBasinZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "submerged_chest",
            name: "Submerged Chest",
            rect: CGRect(x: 616, y: 1704, width: 204, height: 185)
        ),
        SceneHotspot(
            id: "vent",
            name: "Cave Vent Hole",
            rect: CGRect(x: 345, y: 262, width: 588, height: 675)
        ),
        SceneHotspot(
            id: "squirrel",
            name: "Squirrel in Cozy Nook",
            rect: CGRect(x: 1033, y: 1009, width: 221, height: 335)
        ),
        SceneHotspot(
            id: "bats",
            name: "Bats",
            rect: CGRect(x: 176, y: 717, width: 150, height: 298)
        ),
        SceneHotspot(
            id: "plaque",
            name: "Plaque",
            rect: CGRect(x: 55, y: 1981, width: 382, height: 264)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "submerged_chest":
                return !gameState.hasCollectedVintageBrassToken
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasOpenedBasinChest {
            overlays.append(
                SceneOverlayObject(
                    id: "chest_open",
                    imageName: "basin_chest_open_overlay",
                    rect: CGRect(x: 587, y: 1598, width: 313, height: 315)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "cave_and_basin_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Cave and Basin",
                locationSubtitle: "Steam, stone, and old beginnings",
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
        case "submerged_chest":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = gameState.hasInventoryItem(.gaffHook)
                ? .submergedChestWithHook
                : .submergedChestNeedsHook
            
        case "vent":
            activePhoto = Photo.caveAndBasin
            
        case "squirrel":
            showAlert(
                title: "Cozy Squirrel",
                message: "A squirrel has found the warmest nook in the cave and seems deeply unwilling to give up the lease."
            )
            
        case "bats":
            showAlert(
                title: "Bats",
                message: "The bats hang quietly in the mineral-scented dark, ignoring both tourism and legend."
            )
            
        case "plaque":
            showAlert(
                title: "Historic Plaque",
                message: "The plaque explains the official beginning of Canada's national park system. The cave itself feels much older than any plaque."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: CaveAndBasinZoomOverlay) -> some View {
        switch overlay {
        case .submergedChestNeedsHook:
            HotspotZoomOverlay(
                title: "Submerged Chest",
                imageName: "zoom_basin_chest",
                description: "A small chest rests below the surface of the steaming pool. It is too far down to reach by hand.",
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .submergedChestWithHook:
            HotspotZoomOverlay(
                title: "Submerged Chest",
                imageName: "zoom_basin_chest",
                description: "The gaff hook pries the chest open. You notice a brassy vintage token inside.",
                primaryButtonTitle: "Take Token",
                onPrimaryAction: {
                    gameState.hasOpenedBasinChest = true
                    gameState.useInventoryItem(.gaffHook)
                    gameState.collectInventoryItem(.vintageBrassToken)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .vintageBrassToken
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

private enum CaveAndBasinZoomOverlay: Identifiable {
    case submergedChestNeedsHook
    case submergedChestWithHook
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    CaveAndBasinView()
        .environmentObject(GameState())
}
