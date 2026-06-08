//
//  SulphurMountainGondolaView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct SulphurMountainGondolaView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingAlert = false
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 520, y: 980, width: 220, height: 220)),
        SceneHotspot(id: "story_item", name: "Ridge Marker", rect: CGRect(x: 510, y: 1500, width: 260, height: 300))
    ]
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "sulphur_mountain_gondola",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Sulphur Mountain",
                locationSubtitle: "A view from above the pattern",
                onBagTapped: { showingInventory = true }
            )
            
            returnButton
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .alert("Ridge Route Marker", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You record the ridge route marker. From above, the scattered clues begin to form a path.")
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
            activePhotoSymbol = .sulphurMountain
        } else {
            gameState.collectEvidence(.ridgeRouteMarker)
            if let lead = gameState.lead(for: .sulphurMountainGondola) {
                gameState.completeLeadIfNeeded(lead)
            }
            showingAlert = true
        }
    }
}
