//
//  TunnelMountainView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct TunnelMountainView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    @State private var showingIcicleFallSequence = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: TunnelMountainZoomOverlay?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "cave_entrance",
            name: "Boarded Cave Entrance",
            rect: CGRect(x: 802, y: 780, width: 447, height: 690)
        ),
        SceneHotspot(
            id: "bigfoot_footprint",
            name: "Bigfoot Footprint",
            rect: CGRect(x: 896, y: 2152, width: 304, height: 251)
        ),
        SceneHotspot(
            id: "bench",
            name: "Bench",
            rect: CGRect(x: 740, y: 1786, width: 398, height: 344)
        ),
        SceneHotspot(
            id: "snowy_owl",
            name: "Snowy Owl",
            rect: CGRect(x: 59, y: 650, width: 145, height: 234)
        ),
        SceneHotspot(
            id: "fox",
            name: "Fox",
            rect: CGRect(x: 153, y: 1931, width: 164, height: 192)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasReturnedFromBigfootLair || gameState.hasEscapedBigfootLair {
            overlays.append(
                SceneOverlayObject(
                    id: "sealed_cave",
                    imageName: "tunnel_mountain_sealed_cave_overlay",
                    rect: CGRect(x: 802, y: 780, width: 447, height: 690)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "tunnel_mountain_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Tunnel Mountain",
                locationSubtitle: "Tracks between town and timber",
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
            
            if showingIcicleFallSequence {
                IcicleFallSequenceView {
                    showingIcicleFallSequence = false
                    gameState.hasWokenInBigfootLair = true
                    gameState.currentLocation = .bigfootLair
                }
            }
        }
        
        .onAppear {
            SoundManager.shared.stopAllAmbience()
            SoundManager.shared.playAmbience(.mountainWind, volume: 1.0)
        }
        .onDisappear {
            SoundManager.shared.stopAmbience(.mountainWind)
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
        case "cave_entrance":
            SoundManager.shared.play(.tap, volume: 0.35)
            if gameState.hasReturnedFromBigfootLair || gameState.hasEscapedBigfootLair {
                showAlert(
                    title: "Where Did It Go?",
                    message: """
                    I swear there was a cave entrance here.

                    The snow has shifted, the rocks look different, and my head is still fuzzy from the fall.

                    Maybe that is for the best.
                    """
                )
            } else if gameState.hasBrokenCaveEntranceBoards {
                showAlert(
                    title: "Unstable Ice",
                    message: "The broken entrance is too dangerous to approach again."
                )
            } else {
                activeZoomOverlay = gameState.hasInventoryItem(.woodcuttersAxe)
                    ? .caveEntranceWithAxe
                    : .caveEntranceNeedsAxe
            }

            
        case "bigfoot_footprint":
            showAlert(
                title: "Another Huge Footprint",
                message: "This unusually large print is like the one I saw by the museum. I'm not sure I want to meet the owner, but I sure am curious!"
            )
            
        case "bench":
            showAlert(
                title: "Trail Bench",
                message: "The bench offers a perfect view of the trail, the trees, and the realization that something much larger than you recently walked by."
            )
            
        case "snowy_owl":
            activePhoto = Photo.tunnelMountain
            
        case "fox":
            showAlert(
                title: "Fox",
                message: "The fox pauses just long enough to look suspicious, then trots away with the confidence of someone who knows these trails."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: TunnelMountainZoomOverlay) -> some View {
        switch overlay {
        case .caveEntranceNeedsAxe:
            HotspotZoomOverlay(
                title: "Boarded Cave Entrance",
                imageName: "zoom_tunnel_mountain_cave_entrance",
                description: "Old boards block the cave entrance. They are frozen, warped, and too thick to break by hand.",
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .caveEntranceWithAxe:
            HotspotZoomOverlay(
                title: "Boarded Cave Entrance",
                imageName: "zoom_tunnel_mountain_cave_entrance",
                description: """
                I should probably take heed and 'KEEP OUT,' but my curiosity is burning!

                I could probably hack through these boards with an axe. Anything for my next big story, right?!
                """,
                primaryButtonTitle: "Use Axe",
                onPrimaryAction: {
                    gameState.useInventoryItem(.woodcuttersAxe)
                    gameState.hasBrokenCaveEntranceBoards = true
                    gameState.hasTriggeredIcicleFall = true
                    activeZoomOverlay = nil

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showingIcicleFallSequence = true
                    }
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

private enum TunnelMountainZoomOverlay: Identifiable {
    case caveEntranceNeedsAxe
    case caveEntranceWithAxe
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    TunnelMountainView()
        .environmentObject(GameState())
}
