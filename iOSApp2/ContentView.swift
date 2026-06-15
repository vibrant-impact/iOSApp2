//
//  ContentView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if !gameState.hasStartedGame {
                WelcomeView()
            } else {
                currentGameLocationView
            }
        }
        .preferredColorScheme(.dark)
    }
    
    
    // MARK: - Current Location Router
    
    @ViewBuilder
    private var currentGameLocationView: some View {
        switch gameState.currentLocation {
        case .museumExterior:
            MuseumExteriorView()
            
        case .museumInterior:
            MuseumInteriorView()
            
        case .bowFalls:
            BowFallsView()
            
        case .caveAndBasin:
            CaveAndBasinView()
            
        case .banffSpringsHotel:
            BanffSpringsHotelView()
            
        case .downtownBanff:
            DowntownBanffView()
            
        case .hotSprings:
            HotSpringsView()
            
        case .sulphurMountain:
            SulphurMountainView()
            
        case .observatory:
            ObservatoryView()
            
        case .lakeMinnewanka:
            LakeMinnewankaView()
            
        case .tunnelMountain:
            TunnelMountainView()
            
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
