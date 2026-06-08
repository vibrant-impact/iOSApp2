//
//  CaveAndBasinView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// CaveAndBasinView displays the Cave and Basin investigation scene.
///
/// This location has two separate systems:
///
/// 1. Story progression hotspots:
///    - sign
///    - towel
///    - glowing crack
///    - pool object
///
/// 2. Optional photo scavenger hunt hotspot:
///    - photo_symbol
///
/// The optional photo symbol is not required for story progression,
/// but it counts toward discount rewards and endings.
struct CaveAndBasinView: View {
    
    // MARK: - Shared Game State
    
    /// The global game state shared across the app.
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - View State
    
    /// Controls whether the inventory sheet is visible.
    @State private var showingInventory = false
    
    /// Controls whether a normal text alert is visible.
    @State private var showingAlert = false
    
    /// The title shown in the current alert.
    @State private var alertTitle = ""
    
    /// The message shown in the current alert.
    @State private var alertMessage = ""
    
    /// When this has a value, the fake camera opens for that photo symbol.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    
    // MARK: - Scene Setup
    
    /// The original size of the background artwork.
    ///
    /// All hotspot coordinates are based on this canvas size.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// All tappable regions in this scene.
    ///
    /// These rectangles are positioned using coordinates from the original
    /// `1290 x 2796` background image.
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "pool_object",
            name: "Dark Object",
            rect: CGRect(x: 654, y: 1760, width: 198, height: 161)
        ),
        
        SceneHotspot(
            id: "gold_crack",
            name: "Glowing Crack",
            rect: CGRect(x: 123, y: 994, width: 123, height: 224)
        ),
        
        SceneHotspot(
            id: "sign",
            name: "Sign",
            rect: CGRect(x: 38, y: 1866, width: 281, height: 222)
        ),
        
        SceneHotspot(
            id: "towel",
            name: "Towel",
            rect: CGRect(x: 1099, y: 1301, width: 163, height: 227)
        ),
        
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 540, y: 1260, width: 220, height: 220)
        )
    ]
    
    /// Finds the StoryLead connected to Cave and Basin.
    private var caveLead: StoryLead? {
        gameState.lead(for: .caveAndBasin)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background image plus invisible rectangular hotspots.
            ImageSceneView(
                imageName: "cave_and_basin",
                canvasSize: canvasSize,
                hotspots: hotspots,
                
                // Change this to true while adjusting hotspot placement.
                showDebugHotspots: false,
                
                onHotspotTapped: handleHotspotTapped
            )
            
            // Top HUD with title and inventory button.
            TopHUDView(
                locationTitle: "Cave and Basin",
                locationSubtitle: "Steam, stone, and hidden traces",
                onBagTapped: {
                    showingInventory = true
                }
            )
            
            // Bottom return button and progress labels.
            bottomControls
        }
        
        // Inventory sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // General alert for story interactions.
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        
        // Fake camera screen for the optional photo scavenger hunt symbol.
        //
        // Important:
        // This modifier belongs here in the body, not inside handleHotspotTapped.
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { capturedSymbol in
                    gameState.photographSymbol(capturedSymbol)
                }
            )
        }
    }
    
    
    // MARK: - Bottom Controls
    
    /// Displays optional progress labels and the return-to-museum button.
    private var bottomControls: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                
                // Show when the required Cave and Basin story lead is complete.
                if let caveLead, gameState.isLeadCompleted(caveLead) {
                    Label("Cave and Basin lead complete", systemImage: "checkmark.seal.fill")
                        .font(.caption.bold())
                        .foregroundStyle(Color.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.55))
                        .clipShape(Capsule())
                }
                
                // Show when the pool object has been recovered with the net.
                if gameState.hasRecoveredCavePoolObject {
                    Label("Submerged clue recovered", systemImage: "map.fill")
                        .font(.caption.bold())
                        .foregroundStyle(Color.yellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.55))
                        .clipShape(Capsule())
                }
                
                // Return to the museum hub.
                Button {
                    gameState.currentLocation = .museumInterior
                } label: {
                    Label("Return to Museum", systemImage: "arrow.uturn.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
    }
    
    
    // MARK: - Hotspot Routing
    
    /// Called whenever one of the rectangular hotspots is tapped.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "sign":
            handleSignTapped()
            
        case "towel":
            handleTowelTapped()
            
        case "gold_crack":
            handleGoldCrackTapped()
            
        case "pool_object":
            handlePoolObjectTapped()
            
        case "photo_symbol":
            // Opens the fake camera for the optional photo scavenger hunt.
            activePhotoSymbol = .caveAndBasin
            
        default:
            break
        }
    }
    
    
    // MARK: - Story Hotspot Handlers
    
    /// Handles the Cave and Basin sign.
    ///
    /// This is story evidence, not the optional photo scavenger hunt symbol.
    private func handleSignTapped() {
        if gameState.hasEvidence(EvidenceItem.caveSignPhoto.id) {
            showAlert(
                title: "Sign Already Photographed",
                message: """
                You already photographed the Cave and Basin sign.

                The date and wording may matter later. The museum curator will want to see this.
                """
            )
            return
        }
        
        gameState.collectEvidence(.caveSignPhoto)
        
        let completionText = updateCaveLeadCompletionIfNeeded()
        
        showAlert(
            title: "Photograph Taken",
            message: """
            You photograph the historic sign.

            Banff’s official story begins here, with mineral springs, surveyors, and protected land.

            But the warm cave feels older than the sign suggests.
            \(completionText)
            """
        )
    }
    
    /// Handles collecting the old towel from the rocks.
    private func handleTowelTapped() {
        if gameState.hasInventoryItem(InventoryItem.oldTowel.id) {
            showAlert(
                title: "Bare Rocks",
                message: "You already took the old towel from the rocks."
            )
            return
        }
        
        gameState.addInventoryItem(.oldTowel)
        
        showAlert(
            title: "Old Towel Collected",
            message: """
            You lift the towel from the rocks.

            It is stiff with dried mineral water, but the fabric is still usable.

            Added to your bag:
            Old Towel
            """
        )
    }
    
    /// Handles the glowing crack in the wall.
    ///
    /// The player needs the old towel before they can collect the gold dust.
    private func handleGoldCrackTapped() {
        if gameState.hasEvidence(EvidenceItem.goldDustedCloth.id) {
            showAlert(
                title: "Gold Dust Collected",
                message: """
                The glowing crack still catches the light, but you already collected a sample of the fine metallic dust.
                """
            )
            return
        }
        
        guard gameState.hasInventoryItem(InventoryItem.oldTowel.id) else {
            showAlert(
                title: "Glowing Crack",
                message: """
                A narrow crack glows faintly in the wet stone.

                At first it looks like reflected lamplight, but the color is warmer. Metallic.

                Fine gold-colored dust has settled in the mineral crust.

                It is too fine to collect by hand. You need something cloth-like to catch it.
                """
            )
            return
        }
        
        gameState.collectEvidence(.goldDustedCloth)
        
        let completionText = updateCaveLeadCompletionIfNeeded()
        
        showAlert(
            title: "Gold-Dusted Cloth",
            message: """
            You press the old towel carefully against the glowing seam.

            When you pull it away, the fibers glitter with fine gold-colored dust.

            This may be the first physical clue that the Lost Lemon Mine stories are not just stories.
            \(completionText)
            """
        )
    }
    
    /// Handles the dark object at the bottom of the pool.
    ///
    /// The player needs the long-handled net from Bow Falls before retrieving it.
    private func handlePoolObjectTapped() {
        if gameState.hasEvidence(EvidenceItem.sealedOilclothFragment.id) {
            showAlert(
                title: "Pool Checked",
                message: """
                The dark object has already been retrieved from the bottom of the pool.

                The water is still, warm, and strangely clear.
                """
            )
            return
        }
        
        guard gameState.hasInventoryItem(InventoryItem.longHandledNet.id) else {
            showAlert(
                title: "Dark Object Below",
                message: """
                Something dark rests at the bottom of the hot pool, near the center.

                The water is too deep and too hot to reach safely.

                You need something long-handled to retrieve it.
                """
            )
            return
        }
        
        gameState.collectEvidence(.sealedOilclothFragment)
        
        showAlert(
            title: "Oilcloth Fragment Retrieved",
            message: """
            You lower the long-handled net into the hot pool and carefully scoop up the dark object.

            It is a sealed fragment of old oilcloth, water-darkened and heavy.

            Something appears to be protected inside.

            This feels important — not just for Cave and Basin, but for the pattern the museum curator is trying to uncover.
            """
        )
    }
    
    
    // MARK: - Lead Completion Helper
    
    /// Checks if Cave and Basin now has all required evidence.
    ///
    /// Required Cave and Basin story evidence:
    /// - Cave sign photo
    /// - Gold-dusted cloth
    ///
    /// The oilcloth fragment is important for unlocking later locations,
    /// but it is not required to mark Cave and Basin itself as complete.
    private func updateCaveLeadCompletionIfNeeded() -> String {
        guard let caveLead else { return "" }
        
        let wasCompleted = gameState.isLeadCompleted(caveLead)
        gameState.completeLeadIfNeeded(caveLead)
        let isNowCompleted = gameState.isLeadCompleted(caveLead)
        
        if !wasCompleted && isNowCompleted {
            return "\n\nCave and Basin lead complete."
        } else {
            return ""
        }
    }
    
    
    // MARK: - Alert Helper
    
    /// Convenience function for showing alerts.
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Preview

#Preview {
    CaveAndBasinView()
        .environmentObject(GameState())
}
