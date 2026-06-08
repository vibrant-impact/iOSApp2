//
//  BigfootLairView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct BigfootLairView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingSubmission = false
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Bigfoot Photo Symbol", rect: CGRect(x: 520, y: 1120, width: 260, height: 300)),
        SceneHotspot(id: "submit", name: "Submit Results", rect: CGRect(x: 850, y: 1980, width: 300, height: 260))
    ]
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "bigfoot_lair",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "The Hidden Lair",
                locationSubtitle: "The legend was protecting something",
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
                gameState.currentLocation = .lakeMinnewanka
            } label: {
                Label("Return to Lake Minnewanka", systemImage: "arrow.uturn.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "photo_symbol":
            activePhotoSymbol = .bigfootLair
            
        case "submit":
            showingSubmission = true
            
        default:
            break
        }
    }
}
