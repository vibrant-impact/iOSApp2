//
//  BanffSpringsHotelView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct BanffSpringsHotelView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activePhoto: Photo?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "luggage",
            name: "Luggage",
            rect: CGRect(x: 84, y: 2016, width: 495, height: 415)
        ),
        SceneHotspot(
            id: "ghost_bride",
            name: "Ghost Bride",
            rect: CGRect(x: 719, y: 1115, width: 157, height: 132)
        ),
        SceneHotspot(
            id: "horse_drawn_carriage",
            name: "Horse-Drawn Carriage",
            rect: CGRect(x: 290, y: 1731, width: 318, height: 196)
        ),
        SceneHotspot(
            id: "foot_bridge",
            name: "Foot Bridge",
            rect: CGRect(x: 755, y: 1825, width: 409, height: 184)
        ),
        SceneHotspot(
            id: "main_doors",
            name: "Main Doors",
            rect: CGRect(x: 638, y: 1568, width: 257, height: 278)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    /// Hides the ghost bride hotspot after she has been photographed.
    /// The visual scene change is handled by `activeOverlayObjects`.
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "ghost_bride":
                return !gameState.hasPhotographedGhostBride
            default:
                return true
            }
        }
    }
    
    /// Adds/removes visual scene overlays based on game progress.
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasPhotographedGhostBride {
            overlays.append(
                SceneOverlayObject(
                    id: "ghost_gone",
                    imageName: "hotel_ghost_gone_overlay",
                    rect: CGRect(x: 727, y: 1105, width: 169, height: 161)
                )
            )
        }
        
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "hotel_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Banff Springs Hotel",
                locationSubtitle: "Ghosts in the grand old halls",
                onBagTapped: {
                    showingInventory = true
                },
                onJournalTapped: {
                    showingJournal = true
                }
            )
            
            returnButton
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
        
        .onAppear {
            SoundManager.shared.stopAllAmbience()
            SoundManager.shared.playAmbience(.snowyExterior, volume: 1.0)
        }
        .onDisappear {
            SoundManager.shared.stopAmbience(.snowyExterior)
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
        case "luggage":
            showAlert(
                title: "Luggage on Cart",
                message: "A cart of bags sits patiently — proof of new journeys starting from here."
            )
            
        case "ghost_bride":
            activePhoto = Photo.banffSpringsHotel
            
        case "horse_drawn_carriage":
            showAlert(
                title: "Horse-Drawn Carriage",
                message: "The carriage waits in the snow as if expecting guests from another century."
            )
            
        case "foot_bridge":
            showAlert(
                title: "Foot Bridge",
                message: "The bridge crosses into the hotel's winter quiet. Footprints vanish quickly here."
            )
            
        case "main_doors":
            showAlert(
                title: "Grand Entrance",
                message: "The doors are impressive enough to make every visitor feel underdressed."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Alerts
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Preview

#Preview {
    BanffSpringsHotelView()
        .environmentObject(GameState())
}
