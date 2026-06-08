//
//  StoryLocationPlaceholderView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct StoryLocationPlaceholderView: View {
    @EnvironmentObject private var gameState: GameState
    
    let location: Location
    
    @State private var showingInventory = false
    
    private var lead: StoryLead? {
        gameState.lead(for: location)
    }
    
    var body: some View {
        ZStack {
            locationBackground
            
            VStack(spacing: 20) {
                topBar
                
                Spacer()
                
                if let lead {
                    leadContent(lead)
                } else {
                    unknownLocationContent
                }
                
                Spacer()
                
                bottomButtons
            }
            .padding()
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
    }
    
    private var locationBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.08, blue: 0.13),
                Color(red: 0.10, green: 0.16, blue: 0.22),
                Color(red: 0.30, green: 0.38, blue: 0.45)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            SnowfallOverlay()
        }
    }
    
    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(location.displayName)
                    .font(.title2.bold())
                
                Text("Field Investigation")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button {
                showingInventory = true
            } label: {
                Label("Bag", systemImage: "backpack.fill")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func leadContent(_ lead: StoryLead) -> some View {
        VStack(spacing: 18) {
            Image(systemName: lead.systemImage)
                .font(.system(size: 72))
                .foregroundStyle(.orange)
            
            Text(lead.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            Text(lead.subtitle)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Public Mystery")
                    .font(.headline)
                    .foregroundStyle(.yellow)
                
                Text(lead.publicMystery)
                    .foregroundStyle(.white.opacity(0.85))
                
                Divider()
                    .background(.white.opacity(0.25))
                
                Text("The Museum Curator's Note")
                    .font(.headline)
                    .foregroundStyle(.yellow)
                
                Text("“\(lead.curatorNote)”")
                    .italic()
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding()
            .background(.black.opacity(0.28))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            if gameState.isLeadCompleted(lead) {
                Label("Lead explored", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
            } else {
                Button {
                    gameState.completeLead(lead)
                } label: {
                    Label("Record Field Notes", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private var unknownLocationContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.diamond.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
            
            Text("Unknown Location")
                .font(.title.bold())
            
            Text("No story lead has been assigned to this place yet.")
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
        }
    }
    
    private var bottomButtons: some View {
        Button {
            gameState.currentLocation = .museumInterior
        } label: {
            Label("Return to Museum", systemImage: "arrow.uturn.left")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    StoryLocationPlaceholderView(location: .caveAndBasin)
        .environmentObject(GameState())
}
