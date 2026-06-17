//
//  LakeMinnewankaView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct LakeMinnewankaView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: LakeMinnewankaZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "crate",
            name: "Frozen Crate",
            rect: CGRect(x: 782, y: 2281, width: 198, height: 148)
        ),
        SceneHotspot(
            id: "underwater_town",
            name: "Underwater Ghost Town",
            rect: CGRect(x: 125, y: 1413, width: 686, height: 375)
        ),
        SceneHotspot(
            id: "cabin",
            name: "Cabin",
            rect: CGRect(x: 933, y: 1042, width: 351, height: 267)
        ),
        SceneHotspot(
            id: "animals",
            name: "Animals by Campfire",
            rect: CGRect(x: 408, y: 2227, width: 305, height: 343)
        ),
        SceneHotspot(
            id: "rowboat_dock",
            name: "Rowboat and Dock",
            rect: CGRect(x: 688, y: 1922, width: 418, height: 239)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "crate":
                return !gameState.hasCollectedWoodcuttersAxe
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasOpenedMinnewankaCrate {
            overlays.append(
                SceneOverlayObject(
                    id: "crate_open",
                    imageName: "lake_minnewanka_crate_open_overlay",
                    rect: CGRect(x: 756, y: 2259, width: 249, height: 180)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "lake_minnewanka_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Lake Minnewanka",
                locationSubtitle: "A drowned town beneath the ice",
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
        case "crate":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = gameState.hasInventoryItem(.rustyCrowbar)
                ? .crateWithCrowbar
                : .crateNeedsCrowbar
            
        case "underwater_town":
            activePhoto = Photo.lakeMinnewanka
            
        case "cabin":
            showAlert(
                title: "Cabin",
                message: "The cabin looks warm from a distance, which is exactly how cabins trick people in winter."
            )
            
        case "animals":
            showAlert(
                title: "Animals by the Fire",
                message: "The animals seem unusually comfortable together. Either this is a peaceful forest, or someone promised snacks."
            )
            
        case "rowboat_dock":
            showAlert(
                title: "Rowboat and Dock",
                message: "The rowboat is frozen in place. Whatever lies under Lake Minnewanka will have to stay underwater a little longer."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: LakeMinnewankaZoomOverlay) -> some View {
        switch overlay {
        case .crateNeedsCrowbar:
            HotspotZoomOverlay(
                title: "Frozen Crate",
                imageName: "zoom_lake_minnewanka_crate",
                description: "The crate is frozen shut. The lid will not budge by hand.",
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .crateWithCrowbar:
            HotspotZoomOverlay(
                title: "Frozen Crate",
                imageName: "zoom_lake_minnewanka_crate",
                description: "The rusty crowbar bites into the frozen seam. With one hard pull, the crate cracks open. Inside is a woodcutter's axe.",
                primaryButtonTitle: "Take Axe",
                onPrimaryAction: {
                    gameState.hasOpenedMinnewankaCrate = true
                    gameState.useInventoryItem(.rustyCrowbar)
                    gameState.collectInventoryItem(.woodcuttersAxe)
                    activeZoomOverlay = nil
                    collectedItemOverlay = .woodcuttersAxe
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

private enum LakeMinnewankaZoomOverlay: Identifiable {
    case crateNeedsCrowbar
    case crateWithCrowbar
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    LakeMinnewankaView()
        .environmentObject(GameState())
}
