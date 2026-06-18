//
//  MuseumInteriorView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct MuseumInteriorView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    @State private var showingSubmission = false
    @State private var showingCorkboardCloseup = false
    
    @State private var activePhoto: Photo?
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var showingCuratorEnding = false
    @State private var showingCuratorAlert = false
    @State private var curatorAlertTitle = ""
    @State private var curatorAlertMessage = ""
    
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "corkboard",
            name: "Corkboard Hub",
            rect: CGRect(x: 110, y: 1444, width: 299, height: 437)
        ),
        SceneHotspot(
            id: "curator",
            name: "Museum Curator",
            rect: CGRect(x: 37, y: 1877, width: 234, height: 195)
        ),
        SceneHotspot(
            id: "wild_bill_exhibit",
            name: "Wild Bill Peyto Exhibit",
            rect: CGRect(x: 700, y: 1648, width: 386, height: 424)
        ),
        SceneHotspot(
            id: "logbook",
            name: "Visitor Logbook",
            rect: CGRect(x: 198, y: 2044, width: 241, height: 102)
        ),
        SceneHotspot(
            id: "rotary_phone",
            name: "Rotary Phone",
            rect: CGRect(x: 391, y: 1954, width: 130, height: 101)
        ),
        SceneHotspot(
            id: "grizzly_display",
            name: "Grizzly Display",
            rect: CGRect(x: 589, y: 1365, width: 209, height: 195)
        ),
        SceneHotspot(
            id: "porcupine",
            name: "Porcupine",
            rect: CGRect(x: 912, y: 1485, width: 173, height: 151)
        ),
        SceneHotspot(
            id: "squirrel",
            name: "Squirrel",
            rect: CGRect(x: 773, y: 1511, width: 108, height: 111)
        ),
        SceneHotspot(
            id: "fireplace",
            name: "Fireplace",
            rect: CGRect(x: 1118, y: 1364, width: 147, height: 159)
        ),
        SceneHotspot(
            id: "canoe",
            name: "Hanging Canoe",
            rect: CGRect(x: 190, y: 452, width: 519, height: 465)
        ),
        SceneHotspot(
            id: "mountain_goat",
            name: "Mountain Goat",
            rect: CGRect(x: 393, y: 1141, width: 171, height: 146)
        ),
        SceneHotspot(
            id: "moose_head",
            name: "Moose Head",
            rect: CGRect(x: 733, y: 1031, width: 191, height: 199)
        ),
        SceneHotspot(
            id: "raccoon_display",
            name: "Raccoon Display",
            rect: CGRect(x: 256, y: 1255, width: 168, height: 213)
        ),
        SceneHotspot(
            id: "mineral_gems_display",
            name: "Mineral Gems Display",
            rect: CGRect(x: 491, y: 1533, width: 206, height: 195)
        ),
        SceneHotspot(
            id: "owls",
            name: "Owls",
            rect: CGRect(x: 581, y: 1161, width: 162, height: 210)
        ),
        SceneHotspot(
            id: "coal_mining_display",
            name: "Coal Mining Display",
            rect: CGRect(x: 1147, y: 1597, width: 143, height: 339)
        )
    ]
    
    private var activeHotspots: [SceneHotspot] {
        hotspots
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        []
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "museum_interior_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            readabilityGradients
            
            VStack {
                topBar
                    .padding(.horizontal)
                    .padding(.top, 12)
                
                Spacer()
                
                bottomControls
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
        }
        
        .onAppear {
            SoundManager.shared.stopAllAmbience()
            SoundManager.shared.playAmbience(.fireplace, volume: 0.5)
        }
        
        .onDisappear {
            SoundManager.shared.stopAmbience(.fireplace)
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
        
        .sheet(isPresented: $showingJournal) {
            JournalView()
                .environmentObject(gameState)
                .presentationDetents([.medium, .large])
        }
        
        .fullScreenCover(isPresented: $showingCorkboardCloseup) {
            CorkboardFullScreenView()
                .environmentObject(gameState)
        }
        
        .fullScreenCover(isPresented: $showingCuratorEnding) {
            CuratorEndingView()
                .environmentObject(gameState)
        }
        
        .alert(curatorAlertTitle, isPresented: $showingCuratorAlert) {
            Button("OK") { }
        } message: {
            Text(curatorAlertMessage)
        }
        
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Curator Message
    private func handleCuratorTapped() {
        if gameState.hasReturnedFromBigfootLair {
            showingCuratorEnding = true
        } else {
            curatorAlertTitle = "The Museum Curator"
            curatorAlertMessage = """
            The curator looks up from her desk.

            “Save the museum with the story of the century. Find the missing pieces, follow the history, and answer the question I never could.”

            Who guards the Lost Lemon Mine?
            """
            showingCuratorAlert = true
        }
    }
    
    
    // MARK: - Readability Gradients
    
    private var readabilityGradients: some View {
        VStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.72),
                    Color.black.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
            
            Spacer()
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.78)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 360)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
    
    
    // MARK: - Top Bar
    
    private var topBar: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Banff Park Museum")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text("A Historical Treasure Trove")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            
            Spacer()
            
            Button {
                showingJournal = true
            } label: {
                Label("Journal", systemImage: "book.closed.fill")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
            .tint(.yellow)
            
            Button {
                showingInventory = true
            } label: {
                Label("Bag", systemImage: "backpack.fill")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
    
    
    // MARK: - Bottom Controls
    
    private var bottomControls: some View {
        VStack(spacing: 12) {
            
            HStack(spacing: 12) {
                Button {
                    gameState.currentLocation = .museumExterior
                } label: {
                    Label("Outside", systemImage: "door.right.hand.open")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "corkboard":
            showingCorkboardCloseup = true
            
        case "curator":
            handleCuratorTapped()
            
        case "wild_bill_exhibit":
            showAlert(
                title: "Wild Bill Peyto",
                message: "Bill Peyto, aka 'Wild Bill' was a legendary Banff guide, outfitter, and park warden. His photograph prominently marks the entrance to the town. Peyto Glacier on the Continental Divide and Peyto Lake are named in his honour."
            )
            
        case "logbook":
            showAlert(
                title: "Vistor Logbook",
                message: "Visitors logged their names here; doodles outnumber signatures three to one—art wins."
            )
            
        case "rotary_phone":
            showAlert(
                title: "Rotary Phone",
                message: "So outdated it’s charming. Dialing this relic would take a decade."
            )
            
        case "grizzly_display":
            showAlert(
                title: "Grizzly Display",
                message: "The grizzly seems enormous until you remember the curator's question. Maybe not every giant in the Rockies is a bear."
            )
            
        case "porcupine":
            showAlert(
                title: "Porcupine",
                message: "This porcupine looks ready to lecture you—spines up, attitude sharper than its needles."
            )
            
        case "squirrel":
            showAlert(
                title: "Squirrel",
                message: "The squirrel has the expression of someone who has hidden several important things and forgotten where."
            )
            
        case "fireplace":
            showAlert(
                title: "Fireplace",
                message: "Warm light, gentle crackle— like it was built to shelter winter tails and tales."
            )
            
        case "canoe":
            showAlert(
                title: "Hanging Canoe",
                message: "The canoe hangs above the museum floor, a reminder that trails through Banff were never only on land."
            )
            
        case "mountain_goat":
            showAlert(
                title: "Mountain Goat",
                message: "The mountain goat looks perfectly at home on impossible cliffs. Some creatures belong where people struggle to follow."
            )
            
        case "moose_head":
            showAlert(
                title: "Moose Head",
                message: "The moose stares down with calm authority. It has seen many tourists make poor footwear decisions."
            )
            
        case "raccoon_display":
            showAlert(
                title: "Raccoon Display",
                message: "Raccoons never forget a snack. This one’s stuffed, but the mischief still feels alive."
            )
            
        case "mineral_gems_display":
            showAlert(
                title: "Mineral Gems",
                message: "The stones catch the light. Banff's mountains hide beauty, pressure, and old geological secrets."
            )
            
        case "owls":
            showAlert(
                title: "Owls",
                message: "The owls seem to know exactly what you are doing and have chosen not to interfere."
            )
            
        case "coal_mining_display":
            showAlert(
                title: "Coal Mining Display",
                message: "The mining display is a reminder that once people believe there is wealth underground, they rarely leave quietly."
            )
            
        default:
            break
        }
    }
    
    
    // MARK: - Alerts
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}
  

// MARK: - Preview

#Preview {
    MuseumInteriorView()
        .environmentObject(GameState())
}
