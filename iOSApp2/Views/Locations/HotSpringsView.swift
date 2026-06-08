//
//  HotSpringsView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct HotSpringsView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingAlert = false
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 520, y: 1080, width: 220, height: 220)),
        SceneHotspot(id: "story_item", name: "Mineral Token", rect: CGRect(x: 520, y: 1850, width: 220, height: 220))
    ]
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "hot_springs",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Hot Springs",
                locationSubtitle: "Warm refuge in a frozen world",
                onBagTapped: { showingInventory = true }
            )
            
            returnButton
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .alert("Mineral Spring Token", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You record the mineral spring token. Its mark resembles the oilcloth fragment.")
        }
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { gameState.photographSymbol($0) }
            )
        }
    }
    
    private var returnButton: some View {
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
        if hotspot.id == "photo_symbol" {
            activePhotoSymbol = .hotSprings
        } else {
            gameState.collectEvidence(.mineralSpringToken)
            if let lead = gameState.lead(for: .hotSprings) {
                gameState.completeLeadIfNeeded(lead)
            }
            showingAlert = true
        }
    }
}
