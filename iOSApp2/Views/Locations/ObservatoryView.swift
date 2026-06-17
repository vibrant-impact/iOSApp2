//
//  ObservatoryView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-12.
//

import SwiftUI

struct ObservatoryView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var activeZoomOverlay: ObservatoryZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "locker",
            name: "Observatory Locker",
            rect: CGRect(x: 748, y: 1410, width: 207, height: 289)
        ),
        SceneHotspot(
            id: "logbook",
            name: "Observatory Logbook",
            rect: CGRect(x: 955, y: 1214, width: 335, height: 566)
        ),
        SceneHotspot(
            id: "old_equipment",
            name: "Old Observatory Equipment",
            rect: CGRect(x: 20, y: 1217, width: 553, height: 512)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "locker":
                return gameState.hasInventoryItem(.observatoryLockerKey) && !gameState.hasCollectedRustyCrowbar
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasCollectedRustyCrowbar {
            overlays.append(
                SceneOverlayObject(
                    id: "locker_open",
                    imageName: "observatory_lock_gone_overlay",
                    rect: CGRect(x: 744, y: 1466, width: 204, height: 238)
                )
            )
        }
        return overlays
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "observatory_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Sulphur Mountain Observatory",
                locationSubtitle: "Records from the summit",
                onBagTapped: {
                    showingInventory = true
                },
                onJournalTapped: {
                    showingJournal = true
                }
            )
            
            returnButton
            
            if let activeZoomOverlay {
                zoomOverlay(for: activeZoomOverlay)
            }
            
            if let collectedItemOverlay {
                ItemCollectedOverlay(item: collectedItemOverlay) {
                    self.collectedItemOverlay = nil
                }
            }
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        .sheet(isPresented: $showingJournal) {
            JournalView()
                .environmentObject(gameState)
                .presentationDetents([.medium, .large])
        }
        
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    
    // MARK: - Return Button
    
    private var returnButton: some View {
        VStack {
            Spacer()
            
            Button {
                // Transition back to the Sulphur Mountain summit view
                gameState.currentLocation = .sulphurMountain
            } label: {
                Label("Back Outside", systemImage: "arrow.uturn.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "locker":
            SoundManager.shared.play(.tap, volume: 0.35)
            if gameState.hasInventoryItem(.observatoryLockerKey) {
                activeZoomOverlay = .lockerWithKey
            } else {
                // This state should ideally be prevented by activeHotspots logic, but as a fallback:
                showAlert(title: "Locked Cabinet", message: "The cabinet is locked tight. You need a key.")
            }
            
        case "logbook":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = .logbook
            
        case "old_equipment":
            showAlert(
                title: "Old Observatory Equipment",
                message: "The equipment is dusty and dated. Whoever worked here believed logs and measurements mattered — even when no one else was watching."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: ObservatoryZoomOverlay) -> some View {
        switch overlay {
        case .lockerWithKey:
            HotspotZoomOverlay(
                title: "Observatory Locker",
                imageName: "zoom_observatory_lock",
                description: "The locker clicks open with the key. Inside, nestled in an oily cloth, is a rusty crowbar. It looks heavy enough to pry through thick ice or old boards.",
                primaryButtonTitle: "Take Crowbar",
                onPrimaryAction: {
                    gameState.useInventoryItem(.observatoryLockerKey) // Use the key
                    gameState.collectInventoryItem(.rustyCrowbar) // Collect the crowbar
                    activeZoomOverlay = nil
                    collectedItemOverlay = .rustyCrowbar
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .logbook:
            HotspotZoomOverlay(
                title: "Sanson's Logbook",
                imageName: "zoom_observatory_logbook", // Assumes a zoom asset for the logbook
                description: """
                The logbook is full of weather notes, summit conditions, and tiny sketches in the margins.

                One entry is circled:

                “Large tracks visible below Tunnel Mountain after last snowfall. Not bear. Not boot. Direction suggests possible cave access above the timberline.”

                I wonder what's in that cave.
                """,
                primaryButtonTitle: "Add to Journal",
                onPrimaryAction: {
                    gameState.hasReadObservatoryLogbook = true // Mark clue as read
                    activeZoomOverlay = nil
                    collectedItemOverlay = .observatoryStoryLead
                    gameState.collectInventoryItem(.observatoryJournalLead)
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
        }
    }
    
    
    // MARK: - Alerts
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Zoom Overlay Types

private enum ObservatoryZoomOverlay: Identifiable {
    case lockerWithKey
    case logbook
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    ObservatoryView()
        .environmentObject(GameState())
}
