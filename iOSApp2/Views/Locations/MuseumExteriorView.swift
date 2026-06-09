//
//  MuseumExteriorView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI
import Combine

/// The interactive exterior scene for the museum.
///
/// This is one of the player's starting exploration scenes. It displays the
/// museum exterior image and places tappable hotspots over important objects.
///
/// The player can:
/// - read the curator's mailbox note
/// - unlock the museum door with a combination lock
/// - collect the small shovel
/// - photograph the museum exterior photo symbol
/// - open the inventory bag
///
/// This scene leads into `.museumInterior` once the museum door is unlocked.
struct MuseumExteriorView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - check whether the museum door is unlocked
    /// - unlock the museum door
    /// - move the player into the museum interior
    /// - mark the mailbox note as read
    /// - collect the small shovel
    /// - check and record photographed symbols
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    /// Controls whether the curator's mailbox note alert is shown.
    @State private var showingMailboxNote = false
    
    /// Controls whether the combination lock sheet is shown.
    ///
    /// This appears when the player taps the locked museum door.
    @State private var showingDoorLock = false
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    /// Controls whether the shovel feedback alert is shown.
    @State private var showingShovelAlert = false
    
    /// The title for the shovel alert.
    ///
    /// This changes depending on whether the shovel was newly collected or had
    /// already been collected.
    @State private var shovelAlertTitle = ""
    
    /// The body message for the shovel alert.
    @State private var shovelAlertMessage = ""
    
    /// The currently active photo symbol, if the camera view should open.
    ///
    /// Setting this value presents `FakeCameraView` using `.fullScreenCover`.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Data
    
    /// The original design size of the museum exterior image.
    ///
    /// Hotspot rectangles are defined using this coordinate system.
    /// `ImageSceneView` scales the hotspots so they stay aligned with the image
    /// on different device sizes.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// The tappable hotspot areas for the museum exterior scene.
    ///
    /// Each hotspot contains:
    /// - an `id`, used by `handleHotspotTapped(_:)`
    /// - a display `name`, useful for debugging
    /// - a `rect`, positioned in the original `canvasSize` coordinate system
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "mailbox",
            name: "Mailbox",
            rect: CGRect(x: 219, y: 1785, width: 268, height: 323)
        ),
        
        SceneHotspot(
            id: "door",
            name: "Door",
            rect: CGRect(x: 505, y: 1870, width: 184, height: 148)
        ),
        
        SceneHotspot(
            id: "shovel",
            name: "Shovel",
            rect: CGRect(x: 1048, y: 2142, width: 179, height: 266)
        ),
        
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 760, y: 1700, width: 220, height: 220)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // MARK: Scene Image and Hotspots
            
            // Displays the museum exterior background artwork and overlays
            // tappable hotspot rectangles.
            ImageSceneView(
                imageName: "museum_exterior",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            
            // MARK: Top HUD
            
            // Shows the app title/subtitle and the inventory bag button.
            TopHUDView(
                locationTitle: "Heart of the Wild",
                locationSubtitle: "Secrets of Banff",
                onBagTapped: {
                    showingInventory = true
                }
            )
        }
        
        // MARK: Door Lock Sheet
        
        // Presents the combination lock when the player taps the locked door.
        .sheet(isPresented: $showingDoorLock) {
            CombinationLockView(
                correctCode: "1885",
                onUnlock: {
                    
                    // Mark the door as unlocked so future taps can enter
                    // directly without showing the lock again.
                    gameState.isMuseumDoorUnlocked = true
                    
                    // Dismiss the lock sheet.
                    showingDoorLock = false
                    
                    // Wait briefly for the sheet dismissal animation to finish,
                    // then move the player into the museum interior.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        gameState.currentLocation = .museumInterior
                    }
                }
            )
            .presentationDetents([.medium])
        }
        
        // MARK: Inventory Sheet
        
        // Presents the player's inventory bag.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // MARK: Mailbox Note Alert
        
        // Shows the curator's note when the mailbox hotspot is tapped.
        .alert("The museum curator's Note", isPresented: $showingMailboxNote) {
            Button("Got it") {
                
                // Remember that the player has read the note.
                gameState.hasReadMailboxNote = true
            }
        } message: {
            Text("""
            If you are reading this, then the museum doors are still closed and time is shorter than I hoped.

            Start where Banff’s protected story began. The hot springs changed everything, and by 1885 the mountains were no longer just scenery — they had become a promise worth preserving.

            I pinned the first leads inside. Follow the evidence, not the rumours.

            And remember: old museum locks are stubborn, but they usually respect important dates.

            — The Museum Curator
            """)
        }
        
        // MARK: Shovel Alert
        
        // Shows feedback after the player taps the shovel hotspot.
        .alert(shovelAlertTitle, isPresented: $showingShovelAlert) {
            Button("OK") { }
        } message: {
            Text(shovelAlertMessage)
        }
        
        // MARK: Camera View
        
        // Opens the fake camera when the player taps the photo symbol hotspot.
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { capturedSymbol in
                    
                    // Record the photographed symbol in the game state.
                    gameState.photographSymbol(capturedSymbol)
                }
            )
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    /// Handles taps on the museum exterior scene hotspots.
    ///
    /// The hotspot's `id` determines what happens:
    /// - `"mailbox"` shows the curator's note
    /// - `"door"` opens the lock or enters the museum
    /// - `"shovel"` collects the small shovel
    /// - `"photo_symbol"` opens the fake camera
    ///
    /// - Parameter hotspot: The hotspot the player tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "mailbox":
            // Show the curator's note.
            showingMailboxNote = true
            
        case "door":
            // Either open the combination lock or enter the museum.
            handleDoorTapped()
            
        case "shovel":
            // Collect the shovel or show that it was already collected.
            handleShovelTapped()
            
        case "photo_symbol":
            // Open the camera for the museum exterior photo symbol.
            activePhotoSymbol = .museumExterior
            
        default:
            // Ignore unknown hotspot IDs.
            break
        }
    }
    
    
    // MARK: - Door Interaction
    
    /// Handles the museum door hotspot.
    ///
    /// If the door has already been unlocked, the player enters the museum.
    /// Otherwise, the combination lock sheet is shown.
    private func handleDoorTapped() {
        if gameState.isMuseumDoorUnlocked {
            
            // Door is already unlocked, so enter the museum immediately.
            gameState.currentLocation = .museumInterior
            
        } else {
            
            // Door is locked, so show the combination lock puzzle.
            showingDoorLock = true
        }
    }
    
    
    // MARK: - Shovel Interaction
    
    /// Handles the small shovel hotspot.
    ///
    /// If the shovel has not been collected yet, it is added to the player's
    /// inventory through `gameState.collectShovel()`.
    ///
    /// If it has already been collected, the player gets a reminder message.
    private func handleShovelTapped() {
        if gameState.hasCollectedShovel {
            
            // The player already has the shovel.
            shovelAlertTitle = "Already Collected"
            shovelAlertMessage = "You already collected the small shovel."
            
        } else {
            
            // Add the shovel to the player's inventory/game state.
            gameState.collectShovel()
            
            shovelAlertTitle = "Small Shovel Found"
            shovelAlertMessage = "You pull a little metal shovel from the snow and add it to your bag."
        }
        
        // Show the appropriate shovel alert.
        showingShovelAlert = true
    }
}


// MARK: - Preview

#Preview {
    MuseumExteriorView()
        .environmentObject(GameState())
}
