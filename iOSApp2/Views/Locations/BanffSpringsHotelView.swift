//
//  BanffSpringsHotelView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// The interactive investigation scene for the Banff Springs Hotel.
///
/// This view displays the Banff Springs Hotel image scene and places tappable
/// hotspots over important investigation areas.
///
/// The player can:
/// - open the inventory bag
/// - tap hotel clues
/// - collect evidence
/// - photograph a hidden photo symbol
/// - return to the museum
///
/// This location is connected to the `.banffSpringsHotel` story lead.
struct BanffSpringsHotelView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - collect evidence
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
    
    /// The currently active photo symbol, if the camera view should be opened.
    ///
    /// When this value is set, SwiftUI presents `FakeCameraView` using
    /// `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the Banff Springs Hotel image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for this scene.
    ///
    /// Each rectangle is positioned in the coordinate system of `canvasSize`.
    /// `ImageSceneView` scales these rectangles so they line up with the image
    /// on different screen sizes.
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 520, y: 880, width: 220, height: 220)
        ),
        SceneHotspot(
            id: "ledger",
            name: "Guest Ledger",
            rect: CGRect(x: 160, y: 1780, width: 330, height: 260)
        ),
        SceneHotspot(
            id: "service_path",
            name: "Service Path",
            rect: CGRect(x: 850, y: 1900, width: 330, height: 420)
        ),
        SceneHotspot(
            id: "portrait",
            name: "Portrait",
            rect: CGRect(x: 500, y: 850, width: 280, height: 420)
        )
    ]
    
    
    // MARK: - Computed Properties
    
    /// The story lead connected to the Banff Springs Hotel.
    ///
    /// If this lead exists, the view can mark it complete when enough evidence
    /// has been collected.
    private var lead: StoryLead? {
        gameState.lead(for: .banffSpringsHotel)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the hotel background image and adds tappable hotspot
            // rectangles over key investigation areas.
            ImageSceneView(
                imageName: "banff_springs_hotel",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the location title, subtitle, and bag button.
            TopHUDView(
                locationTitle: "Banff Springs Hotel",
                locationSubtitle: "Ghosts in the grand old halls",
                onBagTapped: { showingInventory = true }
            )
            
            
            // MARK: Bottom Navigation
            
            // Adds the return-to-museum button at the bottom of the screen.
            bottomButton
        }
        
        // MARK: Inventory Sheet
        
        // Presents the player's inventory bag.
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
        
        // Opens the fake camera when the player taps a photo symbol hotspot.
        //
        // Because this uses an optional identifiable item, setting
        // `activePhotoSymbol` to a value presents the camera, and setting it
        // back to `nil` dismisses it.
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
    
    /// Handles taps on the Banff Springs Hotel scene hotspots.
    ///
    /// Each hotspot has an `id`, and the switch statement decides what should
    /// happen for that specific area.
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "photo_symbol":
            // Opens the fake camera for the Banff Springs Hotel photo symbol.
            activePhotoSymbol = .banffSpringsHotel
            
        case "ledger":
            // Adds the guest ledger page to the player's collected evidence.
            gameState.collectEvidence(.guestLedgerPage)
            
            // Attempts to complete the related story lead.
            completeLeadIfNeeded()
            
            // Explains what the player discovered.
            showAlert(
                title: "Guest Ledger Page",
                message: "You photograph an old ledger page. One entry mentions a huge figure moving beyond the service paths after midnight."
            )
            
        case "service_path":
            // Adds the service path footprint to the player's collected evidence.
            gameState.collectEvidence(.servicePathFootprint)
            
            // Attempts to complete the related story lead.
            completeLeadIfNeeded()
            
            // Explains what the player discovered.
            showAlert(
                title: "Service Path Footprint",
                message: "You photograph an unusually large footprint near the service path. The ghost story suddenly feels less ghostly."
            )
            
        case "portrait":
            // This clue gives story flavor but does not currently collect evidence.
            showAlert(
                title: "Old Portrait",
                message: "The portrait’s eyes seem to follow you. A handwritten note on the frame mentions winter sightings outside the hotel."
            )
            
        default:
            // Ignore unknown hotspot IDs.
            break
        }
    }
    
    
    // MARK: - Lead Completion
    
    /// Completes the Banff Springs Hotel lead if the game state says it is ready.
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
    BanffSpringsHotelView()
        .environmentObject(GameState())
}
