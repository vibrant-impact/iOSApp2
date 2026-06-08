//
//  TunnelMountainView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct TunnelMountainView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingAlert = false
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 460, y: 1180, width: 220, height: 220)),
        SceneHotspot(id: "story_item", name: "Large Track", rect: CGRect(x: 460, y: 1980, width: 320, height: 260))
    ]
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "tunnel_mountain",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Tunnel Mountain",
                locationSubtitle: "Tracks between town and timber",
                onBagTapped: { showingInventory = true }
            )
            
            returnButton
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .alert("Tunnel Mountain Track", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("You photograph a large track pressed deep into the trail. This is difficult to explain away.")
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
            activePhotoSymbol = .tunnelMountain
        } else {
            gameState.collectEvidence(.tunnelMountainTrack)
            if let lead = gameState.lead(for: .tunnelMountain) {
                gameState.completeLeadIfNeeded(lead)
            }
            showingAlert = true
        }
    }
}
