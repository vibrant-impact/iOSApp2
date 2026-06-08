//
//  BowFallsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct BowFallsView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 560, y: 980, width: 220, height: 220)),
        SceneHotspot(id: "net", name: "Long Net", rect: CGRect(x: 930, y: 1660, width: 250, height: 320)),
        SceneHotspot(id: "snow_marker", name: "Snow Marker", rect: CGRect(x: 190, y: 2050, width: 360, height: 280)),
        SceneHotspot(id: "falls", name: "Falls", rect: CGRect(x: 350, y: 700, width: 600, height: 650))
    ]
    
    private var lead: StoryLead? {
        gameState.lead(for: .bowFalls)
    }
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "bow_falls",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Bow Falls",
                locationSubtitle: "Winter thunder beneath the ice",
                onBagTapped: { showingInventory = true }
            )
            
            bottomButton
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { gameState.photographSymbol($0) }
            )
        }
    }
    
    private var bottomButton: some View {
        VStack {
            Spacer()
            
            Button {
                gameState.currentLocation = .museumInterior
            } label: {
                Label("Return to Museum", systemImage: "arrow.uturn.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "photo_symbol":
            activePhotoSymbol = .bowFalls
            
        case "net":
            handleNetTapped()
            
        case "snow_marker":
            handleSnowMarkerTapped()
            
        case "falls":
            showAlert(
                title: "Bow Falls",
                message: "The frozen roar of the falls echoes through the valley. For a moment, it sounds almost like something answering from the trees."
            )
            
        default:
            break
        }
    }
    
    private func handleNetTapped() {
        gameState.collectEvidence(.parksNetTagPhoto)
        gameState.addInventoryItem(.longHandledNet)
        completeLeadIfNeeded()
        
        showAlert(
            title: "Long-Handled Net Found",
            message: "You photograph the worn Parks tag and collect the long-handled net. This could retrieve something from deep water."
        )
    }
    
    private func handleSnowMarkerTapped() {
        guard gameState.hasInventoryItem(InventoryItem.smallShovel.id) else {
            showAlert(
                title: "Hard-Packed Snow",
                message: "Something is buried under the crusted snow, but you need a tool to clear it."
            )
            return
        }
        
        gameState.collectEvidence(.oldSurveyMarker)
        completeLeadIfNeeded()
        
        showAlert(
            title: "Old Survey Marker",
            message: "You use the small shovel to clear the snow and uncover an old survey marker near the riverbank."
        )
    }
    
    private func completeLeadIfNeeded() {
        guard let lead else { return }
        gameState.completeLeadIfNeeded(lead)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    BowFallsView()
        .environmentObject(GameState())
}
