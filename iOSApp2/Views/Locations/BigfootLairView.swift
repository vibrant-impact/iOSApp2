//
//  BigfootLairView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The final hidden lair scene for the Bigfoot storyline.
///
/// This view displays the Bigfoot lair image scene with interactive hotspots.
/// It is likely used near the end of the investigation, after the player has
/// followed enough evidence to discover where Bigfoot is hiding.
///
/// The player can:
/// - open the inventory bag
/// - photograph the final Bigfoot photo symbol
/// - submit their final investigation results
/// - return to Lake Minnewanka
struct BigfootLairView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - open and display inventory information
    /// - check whether a photo symbol has already been captured
    /// - record newly photographed symbols
    /// - move the player back to Lake Minnewanka
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the ending submission sheet is currently shown.
    ///
    /// This sheet lets the player submit their final evidence/results.
    @State private var showingSubmission = false
    
    /// The currently active photo symbol, if the camera should be opened.
    ///
    /// Setting this value presents `FakeCameraView` through `.fullScreenCover`.
    /// Setting it back to `nil` dismisses the camera.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Bigfoot lair image.
    ///
    /// Hotspot rectangles are defined in this coordinate system.
    /// `ImageSceneView` uses this size to scale hotspots correctly on different
    /// device screens.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Bigfoot lair scene.
    ///
    /// Each hotspot has:
    /// - an `id`, used by `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug labels
    /// - a `rect`, positioned in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Bigfoot Photo Symbol",
            rect: CGRect(x: 520, y: 1120, width: 260, height: 300)
        ),
        SceneHotspot(
            id: "submit",
            name: "Submit Results",
            rect: CGRect(x: 850, y: 1980, width: 300, height: 260)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Bigfoot lair background image and overlays the
            // interactive hotspot rectangles.
            ImageSceneView(
                imageName: "bigfoot_lair",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the current location name, scene subtitle, and bag button.
            TopHUDView(
                locationTitle: "The Hidden Lair",
                locationSubtitle: "The legend was protecting something",
                onBagTapped: { showingInventory = true }
            )
            
            
            // MARK: Return Button
            
            // Adds the bottom button that returns the player to Lake Minnewanka.
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
        
        // Opens the fake camera when the player taps the Bigfoot photo symbol.
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { gameState.photographSymbol($0) }
            )
        }
    }
    
    
    // MARK: - Return Button
    
    /// The bottom navigation button that returns the player to Lake Minnewanka.
    ///
    /// Lake Minnewanka is likely the location that leads into the hidden lair,
    /// so this button acts as the scene's back navigation.
    private var returnButton: some View {
        VStack {
            Spacer()
            
            Button {
                
                // Move the player back to Lake Minnewanka.
                gameState.currentLocation = .lakeMinnewanka
                
            } label: {
                Label("Return to Lake Minnewanka", systemImage: "arrow.uturn.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    /// Handles taps on the Bigfoot lair scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"photo_symbol"` opens the fake camera
    /// - `"submit"` opens the ending submission screen
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "photo_symbol":
            // Opens the camera for the final Bigfoot lair photo symbol.
            activePhotoSymbol = .bigfootLair
            
        case "submit":
            // Opens the ending submission screen where the player can submit
            // their final investigation findings.
            showingSubmission = true
            
        default:
            // Ignore unknown hotspot IDs.
            break
        }
    }
}


// MARK: - Preview

#Preview {
    BigfootLairView()
        .environmentObject(GameState())
}
