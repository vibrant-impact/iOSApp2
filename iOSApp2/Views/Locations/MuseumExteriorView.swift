//
//  MuseumExteriorView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI
import Combine

struct MuseumExteriorView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingMailboxNote = false
    @State private var showingDoorLock = false
    @State private var showingInventory = false
    
    @State private var showingShovelAlert = false
    @State private var shovelAlertTitle = ""
    @State private var shovelAlertMessage = ""
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
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
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "museum_exterior",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Heart of the Wild",
                locationSubtitle: "Secrets of Banff",
                onBagTapped: {
                    showingInventory = true
                }
            )
        }
        .sheet(isPresented: $showingDoorLock) {
            CombinationLockView(
                correctCode: "1885",
                onUnlock: {
                    gameState.isMuseumDoorUnlocked = true
                    showingDoorLock = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        gameState.currentLocation = .museumInterior
                    }
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .alert("The museum curator's Note", isPresented: $showingMailboxNote) {
            Button("Got it") {
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
        .alert(shovelAlertTitle, isPresented: $showingShovelAlert) {
            Button("OK") { }
        } message: {
            Text(shovelAlertMessage)
        }
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
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "mailbox":
            showingMailboxNote = true
            
        case "door":
            handleDoorTapped()
            
        case "shovel":
            handleShovelTapped()
            
        case "photo_symbol":
            activePhotoSymbol = .museumExterior
            
        default:
            break
        }
    }
    
    private func handleDoorTapped() {
        if gameState.isMuseumDoorUnlocked {
            gameState.currentLocation = .museumInterior
        } else {
            showingDoorLock = true
        }
    }
    
    private func handleShovelTapped() {
        if gameState.hasCollectedShovel {
            shovelAlertTitle = "Already Collected"
            shovelAlertMessage = "You already collected the small shovel."
        } else {
            gameState.collectShovel()
            shovelAlertTitle = "Small Shovel Found"
            shovelAlertMessage = "You pull a little metal shovel from the snow and add it to your bag."
        }
        
        showingShovelAlert = true
    }
}

#Preview {
    MuseumExteriorView()
        .environmentObject(GameState())
}
