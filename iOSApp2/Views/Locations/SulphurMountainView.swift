//
//  SulphurMountainView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-12.
//

import SwiftUI

struct SulphurMountainView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: SulphurMountainZoomOverlay?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "observatory_door", // Renamed for clarity
            name: "Observatory Door",
            rect: CGRect(x: 859, y: 752, width: 223, height: 278)
        ),
        SceneHotspot(
            id: "sansons_sign",
            name: "Sanson's Peak Sign",
            rect: CGRect(x: 978, y: 2056, width: 212, height: 205)
        ),
        SceneHotspot(
            id: "banff_town_view", // Renamed for clarity
            name: "View of Banff Below",
            rect: CGRect(x: 284, y: 830, width: 466, height: 244)
        ),
        SceneHotspot(
            id: "bighorn_sheep",
            name: "Bighorn Sheep",
            rect: CGRect(x: 536, y: 1231, width: 148, height: 142)
        ),
        SceneHotspot(
            id: "gondola_station",
            name: "Gondola Station",
            rect: CGRect(x: 153, y: 1441, width: 513, height: 486)
        )
    ]
    
    
    // MARK: - Body
    
    private var activeHotspots: [SceneHotspot] {
        hotspots
    }
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "sulphur_mountain_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Sulphur Mountain",
                locationSubtitle: "A view from above the pattern",
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
        case "observatory_door":
            if gameState.hasMeltedWeatherStationDoorIce {
                gameState.currentLocation = .observatory
            } else if gameState.hasInventoryItem(.woodenMatches) {
                activeZoomOverlay = .doorNeedsMeltWithMatches
            } else {
                activeZoomOverlay = .doorNeedsMelt
            }
            
        case "sansons_sign":
            showAlert(
                title: "Sanson's Peak Sign",
                message: "The sign names this peak after Norman Sanson, the museum's first curator. He climbed this mountain over 1,000 times to record weather data."
            )
            
        case "banff_town_view":
            activePhoto = Photo.sulphurMountain
            
        case "bighorn_sheep":
            showAlert(
                title: "Bighorn Sheep",
                message: "A bighorn sheep pauses on a precarious ledge, a perfect picture of mountain resilience."
            )
            
        case "gondola_station":
            showAlert(
                title: "Gondola Station",
                message: "The gondola station offers a warm retreat from the summit winds. It connects the base to this grand viewpoint daily."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: SulphurMountainZoomOverlay) -> some View {
        switch overlay {
        case .doorNeedsMelt:
            HotspotZoomOverlay(
                title: "Frozen Observatory Door",
                imageName: "zoom_sulphur_mountain_observatory_door",
                description: "The observatory door is frozen shut. You need something hot enough to melt the seal.",
                primaryButtonTitle: "Close",
                onPrimaryAction: { activeZoomOverlay = nil },
                onClose: { activeZoomOverlay = nil }
            )
            
        case .doorNeedsMeltWithMatches:
            HotspotZoomOverlay(
                title: "Frozen Observatory Door",
                imageName: "zoom_sulphur_mountain_observatory_door",
                description: "The wooden matches might be just enough heat to melt the ice. The wind howls, but the flame holds steady.",
                primaryButtonTitle: "Use Matches",
                onPrimaryAction: {
                    gameState.useInventoryItem(.woodenMatches)
                    gameState.hasMeltedWeatherStationDoorIce = true
                    activeZoomOverlay = nil
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        gameState.currentLocation = .observatory
                    }
                },
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

private enum SulphurMountainZoomOverlay: Identifiable {
    case doorNeedsMelt
    case doorNeedsMeltWithMatches
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    SulphurMountainView()
        .environmentObject(GameState())
}
