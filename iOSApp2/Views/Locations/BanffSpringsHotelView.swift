//
//  BanffSpringsHotelView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct BanffSpringsHotelView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var activePhotoSymbol: PhotoSymbol?
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(id: "photo_symbol", name: "Photo Symbol", rect: CGRect(x: 520, y: 880, width: 220, height: 220)),
        SceneHotspot(id: "ledger", name: "Guest Ledger", rect: CGRect(x: 160, y: 1780, width: 330, height: 260)),
        SceneHotspot(id: "service_path", name: "Service Path", rect: CGRect(x: 850, y: 1900, width: 330, height: 420)),
        SceneHotspot(id: "portrait", name: "Portrait", rect: CGRect(x: 500, y: 850, width: 280, height: 420))
    ]
    
    private var lead: StoryLead? {
        gameState.lead(for: .banffSpringsHotel)
    }
    
    var body: some View {
        ZStack {
            ImageSceneView(
                imageName: "banff_springs_hotel",
                canvasSize: canvasSize,
                hotspots: hotspots,
                showDebugHotspots: true,
                onHotspotTapped: handleHotspotTapped
            )
            
            TopHUDView(
                locationTitle: "Banff Springs Hotel",
                locationSubtitle: "Ghosts in the grand old halls",
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
            activePhotoSymbol = .banffSpringsHotel
            
        case "ledger":
            gameState.collectEvidence(.guestLedgerPage)
            completeLeadIfNeeded()
            showAlert(
                title: "Guest Ledger Page",
                message: "You photograph an old ledger page. One entry mentions a huge figure moving beyond the service paths after midnight."
            )
            
        case "service_path":
            gameState.collectEvidence(.servicePathFootprint)
            completeLeadIfNeeded()
            showAlert(
                title: "Service Path Footprint",
                message: "You photograph an unusually large footprint near the service path. The ghost story suddenly feels less ghostly."
            )
            
        case "portrait":
            showAlert(
                title: "Old Portrait",
                message: "The portrait’s eyes seem to follow you. A handwritten note on the frame mentions winter sightings outside the hotel."
            )
            
        default:
            break
        }
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
    BanffSpringsHotelView()
        .environmentObject(GameState())
}
