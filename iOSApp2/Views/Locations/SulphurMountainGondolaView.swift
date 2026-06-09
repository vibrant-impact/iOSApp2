//
//  SulphurMountainGondolaView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for the Sulphur Mountain Gondola.
///
/// This view displays the Sulphur Mountain Gondola image scene with tappable
/// hotspots placed over important clue areas.
///
/// The player can:
/// - open the inventory bag
/// - photograph the Sulphur Mountain photo symbol
/// - collect the ridge route marker evidence
/// - complete the related Sulphur Mountain Gondola lead when ready
/// - return to the museum
struct SulphurMountainGondolaView: View {
    
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
    
    /// Controls whether the ridge route marker alert is currently shown.
    @State private var showingAlert = false
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Sulphur Mountain Gondola image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they stay aligned with the image
    /// on different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Sulphur Mountain Gondola scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used in `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug overlays
    /// - a `rect`, positioned in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 520, y: 980, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "story_item",
            name: "Ridge Marker",
            rect: CGRect(x: 510, y: 1500, width: 260, height: 300)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Sulphur Mountain Gondola background artwork and
            // overlays the tappable hotspot rectangles.
            ImageSceneView(
                imageName: "sulphur_mountain_gondola",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the current location title, subtitle, and bag button.
            TopHUDView(
                locationTitle: "Sulphur Mountain",
                locationSubtitle: "A view from above the pattern",
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
        
        // MARK: Ridge Marker Alert
        
        // Shows after the player taps the ridge route marker hotspot.
        .alert("Ridge Route Marker", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You record the ridge route marker. From above, the scattered clues begin to form a path.")
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
    
    /// Handles taps on the Sulphur Mountain Gondola scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"photo_symbol"` opens the fake camera
    /// - any other hotspot currently records the
