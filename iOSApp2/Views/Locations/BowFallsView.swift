//
//  BowFallsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for Bow Falls.
///
/// This view displays the Bow Falls image scene with tappable hotspots placed
/// over important clue areas.
///
/// The player can:
/// - open the inventory bag
/// - photograph the Bow Falls photo symbol
/// - collect a long-handled net
/// - use the small shovel to uncover a buried survey marker
/// - inspect the falls
/// - return to the museum
///
/// This location is connected to the `.bowFalls` story lead.
struct BowFallsView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - collect evidence
    /// - add inventory items
    /// - check whether the player has required tools
    /// - complete the related story lead
    /// - check photographed symbols
    /// - change the current location
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the clue alert is currently shown.
    @State private var showingAlert = false
    
    /// The title displayed in the current alert.
    @State private var alertTitle = ""
    
    /// The message displayed in the current alert.
    @State private var alertMessage = ""
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Bow Falls image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they line up with the image on
    /// different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the Bow Falls scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used in `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debug overlays
    /// - a `rect`, placed in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 560, y: 980, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "net",
            name: "Long Net",
            rect: CGRect(x: 930, y: 1660, width: 250, height: 320)
        ),
        SceneHotspot(
            id: "snow_marker",
            name: "Snow Marker",
            rect: CGRect(x: 190, y: 2050, width: 360, height: 280)
        ),
        SceneHotspot(
            id: "falls",
            name: "Falls",
            rect: CGRect(x: 350, y: 700, width: 600, height: 650)
        )
    ]
    
    
    // MARK: - Computed Properties
    
    /// The story lead connected to Bow Falls.
    ///
    /// If this lead exists, the view can ask `GameState` to complete it when
    /// the required evidence has been collected.
    private var lead: StoryLead? {
        gameState.lead(for: .bowFalls)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the Bow Falls background artwork and overlays tappable
            // hotspot rectangles.
            ImageSceneView(
                imageName: "bow_falls",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the location title, subtitle, and inventory bag button.
            TopHUDView(
                locationTitle: "Bow Falls",
                locationSubtitle: "Winter thunder beneath the ice",
                onBagTapped: { showingInventory = true }
            )
            
            
            // MARK: Bottom Navigation
            
            // Adds the return-to-museum button at the bottom of the screen.
            bottomButton
        }
        
        // MARK: Inventory Sheet
        
        // Presents the player's inventory bag as a medium-height sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // MARK: Clue Alert
        
        // Shows clue descriptions after the player taps certain hotspots.
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
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
    
    
    // MARK: - Bottom Button
    
    /// The button that returns the player to the museum interior.
    private var bottomButton: some View {
        VStack {
            Spacer()
            
            Button {
                
                // Move the player back to the museum.
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
    
    /// Handles taps on the Bow Falls scene hotspots.
    ///
    /// The hotspot's `id` determines which interaction should happen.
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "photo_symbol":
            // Opens the fake camera for the Bow Falls photo symbol.
            activePhotoSymbol = .bowFalls
            
        case "net":
            // Handles collecting the long-handled net and its evidence photo.
            handleNetTapped()
            
        case "snow_marker":
            // Handles the buried survey marker interaction.
            // This requires the small shovel.
            handleSnowMarkerTapped()
            
        case "falls":
            // Atmospheric story detail for inspecting the frozen falls.
            showAlert(
                title: "Bow Falls",
                message: "The frozen roar of the falls echoes through the valley. For a moment, it sounds almost like something answering from the trees."
            )
            
        default:
            // Ignore unknown hotspot IDs.
            break
        }
    }
    
    
    // MARK: - Net Interaction
    
    /// Handles the long-handled net hotspot.
    ///
    /// This interaction:
    /// - collects the Parks net tag evidence
    /// - adds the long-handled net to the player's inventory
    /// - checks whether the Bow Falls lead can now be completed
    /// - shows an explanatory alert
    private func handleNetTapped() {
        
        // Record evidence that the player photographed the Parks tag.
        gameState.collectEvidence(.parksNetTagPhoto)
        
        // Add the long-handled net as a usable inventory item.
        gameState.addInventoryItem(.longHandledNet)
        
        // Attempt to complete the connected Bow Falls lead.
        completeLeadIfNeeded()
        
        showAlert(
            title: "Long-Handled Net Found",
            message: "You photograph the worn Parks tag and collect the long-handled net. This could retrieve something from deep water."
        )
    }
    
    
    // MARK: - Snow Marker Interaction
    
    /// Handles the buried snow marker hotspot.
    ///
    /// The player must have the small shovel before they can clear the snow.
    /// If they do not have it, the view shows a hint alert instead.
    private func handleSnowMarkerTapped() {
        
        // Require the small shovel before the player can dig up the marker.
        guard gameState.hasInventoryItem(InventoryItem.smallShovel.id) else {
            showAlert(
                title: "Hard-Packed Snow",
                message: "Something is buried under the crusted snow, but you need a tool to clear it."
            )
            return
        }
        
        // The player has the shovel, so the buried survey marker can be found.
        gameState.collectEvidence(.oldSurveyMarker)
        
        // Attempt to complete the connected Bow Falls lead.
        completeLeadIfNeeded()
        
        showAlert(
            title: "Old Survey Marker",
            message: "You use the small shovel to clear the snow and uncover an old survey marker near the riverbank."
        )
    }
    
    
    // MARK: - Lead Completion
    
    /// Completes the Bow Falls lead if the game state says it is ready.
    ///
    /// This safely exits if no matching lead exists.
    private func completeLeadIfNeeded() {
        guard let lead else { return }
        gameState.completeLeadIfNeeded(lead)
    }
    
    
    // MARK: - Alerts
    
    /// Shows a simple alert with a title and message.
    ///
    /// - Parameters:
    ///   - title: The alert title.
    ///   - message: The alert body text.
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Preview

#Preview {
    BowFallsView()
        .environmentObject(GameState())
}
