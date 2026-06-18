//
//  BowFallsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct BowFallsView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: BowFallsZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "buried_canister",
            name: "Buried Canister",
            rect: CGRect(x: 185, y: 1862, width: 303, height: 253)
        ),
        SceneHotspot(
            id: "gaff_hook",
            name: "Gaff Hook",
            rect: CGRect(x: 935, y: 1698, width: 154, height: 462)
        ),
        SceneHotspot(
            id: "douglas_fir_trees",
            name: "Douglas Fir Trees",
            rect: CGRect(x: 844, y: 0, width: 446, height: 1439)
        ),
        SceneHotspot(
            id: "frozen_falls",
            name: "Frozen Falls",
            rect: CGRect(x: 243, y: 830, width: 482, height: 634)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "gaff_hook":
                return !gameState.hasCollectedGaffHook
            case "buried_canister":
                return !gameState.hasCollectedWoodenMatches
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasCollectedWoodenMatches {
            overlays.append(
                SceneOverlayObject(
                    id: "canister_gone",
                    imageName: "falls_canister_gone_overlay",
                    rect: CGRect(x: 237, y: 1894, width: 201, height: 175)
                )
            )
        }
        
        if gameState.hasCollectedGaffHook {
            overlays.append(
                SceneOverlayObject(
                    id: "hook_gone",
                    imageName: "falls_gaff_hook_gone_overlay",
                    rect: CGRect(x: 769, y: 1665, width: 372, height: 635)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "bow_falls_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Bow Falls",
                locationSubtitle: "Winter thunder beneath the ice",
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
            SoundManager.shared.playAmbience(.snowyExterior, volume: 1.0)
        }
        
        .onDisappear {
            SoundManager.shared.play(.locationTravel, volume: 0.45)
            SoundManager.shared.stopAmbience(.snowyExterior)
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
        case "gaff_hook":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = .gaffHook
            
        case "buried_canister":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = gameState.hasInventoryItem(.smallShovel)
                ? .buriedCanisterWithShovel
                : .buriedCanisterNeedsShovel
            
        case "douglas_fir_trees":
            activePhoto = Photo.bowFalls
            
        case "frozen_falls":
            showAlert(
                title: "Frozen Falls",
                message: "The frozen falls hang in mid-roar—Banff’s spray trapped in glassy time. Still, beautiful, and silent."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: BowFallsZoomOverlay) -> some View {
        switch overlay {
        case .gaffHook:
            HotspotZoomOverlay(
                title: "Gaff Hook",
                imageName: "zoom_falls_gaff_hook",
                description: "A long gaff hook rests against the icy boulder. The metal hook is scratched but sturdy.",
                primaryButtonTitle: "Take Gaff Hook",
                onPrimaryAction: {
                    gameState.collectInventoryItem(.gaffHook)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .gaffHook
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .buriedCanisterNeedsShovel:
            HotspotZoomOverlay(
                title: "Packed Snowdrift",
                imageName: "zoom_falls_canister",
                description: "Something is buried beneath the crusted snow, but the drift is too hard to clear by hand.",
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .buriedCanisterWithShovel:
            HotspotZoomOverlay(
                title: "Buried Canister",
                imageName: "zoom_falls_canister",
                description: "The small shovel cuts through the packed snow. Beneath the drift, you uncover a sealed canister filled with dry wooden matches.",
                primaryButtonTitle: "Take Wooden Matches",
                onPrimaryAction: {
                    gameState.hasOpenedFallsCanister = true
                    gameState.useInventoryItem(.smallShovel)
                    gameState.collectInventoryItem(.woodenMatches)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .woodenMatches
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

private enum BowFallsZoomOverlay: Identifiable {
    case gaffHook
    case buriedCanisterNeedsShovel
    case buriedCanisterWithShovel
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    BowFallsView()
        .environmentObject(GameState())
}
