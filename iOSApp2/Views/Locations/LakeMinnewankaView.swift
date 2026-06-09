//
//  LakeMinnewankaView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for Lake Minnewanka.
///
/// This view displays the Lake Minnewanka image scene with tappable hotspots.
/// It appears to be one of the late-game locations where the final clues gather.
///
/// The player can:
/// - open the inventory bag
/// - photograph the Lake Minnewanka photo symbol
/// - discover the hidden path to Bigfoot's lair
/// - submit final investigation results
/// - return to the museum
struct LakeMinnewankaView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - check photographed symbols
    /// - record newly photographed symbols
    /// - move between locations
    /// - show inventory information
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the ending submission sheet is currently shown.
    ///
    /// This allows the player to submit their final evidence/results.
    @State private var showingSubmission = false
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Lake Minnewanka image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they stay aligned with the image
    /// on different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Lake Minnewanka scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used by `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug overlays
    /// - a `rect`, placed in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 520, y: 1080, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "bigfoot_path",
            name: "Hidden Path",
            rect: CGRect(x: 860, y: 1880, width: 280, height: 360)
        ),
        SceneHotspot(
            id: "submit",
            name: "Submit",
            rect: CGRect(x: 120, y: 1980, width: 300, height: 260)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Lake Minnewanka background artwork and overlays the
            // tappable hotspot rectangles.
            ImageSceneView(
                imageName: "lake_minnewanka",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the current location title, subtitle, and bag button.
            TopHUDView(
                locationTitle: "Lake Minnewanka",
                locationSubtitle: "Where the last clues gather",
                onBagTapped: { showingInventory = true }
            )
            
            
            // MARK: Return Button
            
            // Adds the bottom button that returns the player to the museum.
            returnButton
        }
        
        // MARK: Inventory Sheet
        
        // Presents the player's inventory bag as a medium-height sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // MARK: Ending Submission Sheet
        
        // Presents the final evidence/result submission screen.
        .sheet(isPresented: $showingSubmission) {
            EndingSubmissionView()
                .environmentObject(gameState)
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
    
    /// Handles taps on the Lake Minnewanka scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"photo_symbol"` opens the fake camera
    /// - `"bigfoot_path"` moves the player to Bigfoot's hidden lair
    /// - `"submit"` opens the ending submission screen
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "photo_symbol":
            // Opens the camera for the Lake Minnewanka photo symbol.
            activePhotoSymbol = .lakeMinnewanka
            
        case "bigfoot_path":
            // Move the player into the hidden Bigfoot lair scene.
            gameState.currentLocation = .bigfootLair
            
        case "submit":
            // Open the final submission sheet.
            showingSubmission = true
            
        default:
            // Ignore unknown hotspot IDs.
            break
        }
    }
}


// MARK: - Preview

#Preview {
    LakeMinnewankaView()
        .environmentObject(GameState())
}
