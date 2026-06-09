//
//  TunnelMountainView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for Tunnel Mountain.
///
/// This view displays the Tunnel Mountain image scene with tappable hotspots
/// placed over important clue areas.
///
/// The player can:
/// - open the inventory bag
/// - photograph the Tunnel Mountain photo symbol
/// - collect the large track evidence
/// - complete the related Tunnel Mountain lead when ready
/// - return to the museum
struct TunnelMountainView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - show inventory information
    /// - collect evidence
    /// - complete the related story lead
    /// - check photographed symbols
    /// - record newly photographed symbols
    /// - change the current location
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the large track alert is currently shown.
    @State private var showingAlert = false
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Tunnel Mountain image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they stay aligned with the image
    /// on different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Tunnel Mountain scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used in `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug overlays
    /// - a `rect`, positioned in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 460, y: 1180, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "story_item",
            name: "Large Track",
            rect: CGRect(x: 460, y: 1980, width: 320, height: 260)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Tunnel Mountain background artwork and overlays the
            // tappable hotspot rectangles.
            ImageSceneView(
                imageName: "tunnel_mountain",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the current location title, subtitle, and bag button.
            TopHUDView(
                locationTitle: "Tunnel Mountain",
                locationSubtitle: "Tracks between town and timber",
                onBagTapped: { showingInventory = true }
            )
            
            
            // MARK: Return Button
            
            // Adds the bottom return-to-museum button.
            returnButton
        }
        
        // MARK: Inventory Sheet
        
        // Presents the player's inventory bag as a medium-height sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // MARK: Track Alert
        
        // Shows after the player taps the large track hotspot.
        .alert("Tunnel Mountain Track", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You photograph a large track pressed deep into the trail. This is difficult to explain away.")
        }
        
        // MARK: Camera View
        
        // Opens the fake camera when the player taps the photo symbol hotspot.
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { gameState.photographSymbol($0) }
            )
        }
    }
    
    
    // MARK: - Return Button
    
    /// The bottom navigation button that returns the player to the museum.
    private var returnButton: some View {
        VStack {
            Spacer()
            
            Button {
                
                // Move the player back to the museum interior.
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
    
    /// Handles taps on the Tunnel Mountain scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"photo_symbol"` opens the fake camera
    /// - any other hotspot currently records the large track evidence
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        
        // The photo symbol opens the camera instead of collecting evidence.
        if hotspot.id == "photo_symbol" {
            activePhotoSymbol = .tunnelMountain
            
        } else {
            
            // Record the Tunnel Mountain track as collected evidence.
            gameState.collectEvidence(.tunnelMountainTrack)
            
            // If a story lead is connected to Tunnel Mountain, ask the game
            // state to complete it if its requirements have been met.
            if let lead = gameState.lead(for: .tunnelMountain) {
                gameState.completeLeadIfNeeded(lead)
            }
            
            // Show the player a short clue description.
            showingAlert = true
        }
    }
}
