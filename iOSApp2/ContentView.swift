//
//  ContentView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    // MARK: - Shared Game State
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Show the welcome screen before the player starts.
            if !gameState.hasStartedGame {
                WelcomeView()
            } else {
                currentGameLocationView
            }
        }
        .preferredColorScheme(.dark)
    }
    
    
    // MARK: - Current Location Router
    
    /// Chooses which game view to display based on the current location.
    @ViewBuilder
    private var currentGameLocationView: some View {
        switch gameState.currentLocation {
        case .museumExterior:
            MuseumExteriorView()
            
        case .museumInterior:
            MuseumInteriorView()
            
        case .caveAndBasin:
            CaveAndBasinView()
            
        case .bowFalls:
            BowFallsView()
            
        case .banffSpringsHotel:
            BanffSpringsHotelView()
            
        case .hotSprings:
            HotSpringsView()
            
        case .sulphurMountainGondola:
            SulphurMountainGondolaView()
            
        case .tunnelMountain:
            TunnelMountainView()
            
        case .lakeMinnewanka:
            LakeMinnewankaView()
            
        case .bigfootLair:
            BigfootLairView()
        }
    }
}


// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(GameState())
}
