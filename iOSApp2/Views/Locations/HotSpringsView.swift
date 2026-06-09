//
//  HotSpringsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for the Hot Springs location.
///
/// This view displays the Hot Springs image scene with tappable hotspots placed
/// over important clue areas.
///
/// The player can:
/// - open the inventory bag
/// - photograph the Hot Springs photo symbol
/// - collect the mineral spring token evidence
/// - complete the related Hot Springs lead when ready
/// - return to the museum
struct HotSpringsView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - open inventory information
    /// - collect evidence
    /// - complete the related story lead
    /// - check photographed symbols
    /// - record newly photographed symbols
    /// - change the current location
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the mineral token alert is currently shown.
    @State private var showingAlert = false
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Hot Springs image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they stay aligned with the image
    /// on different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Hot Springs scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used in `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug overlays
    /// - a `rect`, placed in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 520, y: 1080, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "story_item",
            name: "Mineral Token",
            rect: CGRect(x: 520, y: 1850, width: 220, height: 220)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Hot Springs background artwork and overlays tappable
            // hotspot rectangles.
            ImageSceneView(
                imageName: "hot_springs",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the location title, subtitle, and inventory bag button.
            TopHUDView(
                locationTitle: "Hot Springs",
                locationSubtitle: "Warm refuge in a frozen world",
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
        
        // MARK: Mineral Token Alert
        
        // Shows after the player taps the mineral token hotspot.
        .alert("Mineral Spring Token", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You record the mineral spring token. Its mark resembles the oilcloth fragment.")
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
    
    /// Handles taps on the Hot Springs scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"photo_symbol"` opens the fake camera
    /// - any other hotspot currently records the mineral spring token evidence
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        
        // The photo symbol opens the camera instead of collecting evidence.
        if hotspot.id == "photo_symbol" {
            activePhotoSymbol = .hotSprings
            
        } else {
            
            // Record the mineral spring token as collected evidence.
            gameState.collectEvidence(.mineralSpringToken)
            
            // If a story lead is connected to the Hot Springs location,
            // ask the game state to complete it if its requirements are met.
            if let lead = gameState.lead(for: .hotSprings) {
                gameState.completeLeadIfNeeded(lead)
            }
            
            // Show the player a short clue description.
            showingAlert = true
        }
    }
}
