//
//  LakeMinnewankaView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct LakeMinnewankaView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingSubmission = false
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 520, y: 1080, width: 220, height: 220)),
        SceneHotspot(id: "bigfoot_path", name: "Hidden Path", rect: CGRect(x: 860, y: 1880, width: 280, height: 360)),
        SceneHotspot(id: "submit", name: "Submit", rect: CGRect(x: 120, y: 1980, width: 300, height: 260))
    ]
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "lake_minnewanka",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Lake Minnewanka",
                locationSubtitle: "Where the last clues gather",
                onBagTapped: { showingInventory = true }
            )
            
            returnButton
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingSubmission) {
            EndingSubmissionView()
                .environmentObject(gameState)
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
        switch hotspot.id {
        case "photo_symbol":
            activePhotoSymbol = .lakeMinnewanka
            
        case "bigfoot_path":
            gameState.currentLocation = .bigfootLair
            
        case "submit":
            showingSubmission = true
            
        default:
            break
        }
    }
}
