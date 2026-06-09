//
//  StoryLocationPlaceholderView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A temporary story-location screen used for investigation locations.
///
/// This view acts as a placeholder for locations that do not yet have a full
/// custom scene built with background artwork, hotspots, or puzzles.
///
/// It displays:
/// - the location name
/// - the related story lead, if one exists
/// - the public mystery
/// - the curator's note
/// - a button to record field notes
/// - access to the player's bag
/// - a return button back to the museum
struct StoryLocationPlaceholderView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This is used to:
    /// - find the lead connected to this location
    /// - check if the lead has been completed
    /// - complete the lead
    /// - return the player to the museum
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Input Properties
    
    /// The location being displayed by this placeholder screen.
    let location: Location
    
    
    // MARK: - State
    
    /// Controls whether the inventory sheet is currently shown.
    @State private var showingInventory = false
    
    
    // MARK: - Computed Properties
    
    /// Finds the story lead connected to this location.
    ///
    /// If no lead has been assigned to the location, this value is `nil`,
    /// and the view shows the unknown-location message instead.
    private var lead: StoryLead? {
        gameState.lead(for: location)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Background gradient and snow effect.
            locationBackground
            
            VStack(spacing: 20) {
                
                // Location title and bag button.
                topBar
                
                Spacer()
                
                // Show the story lead if this location has one.
                // Otherwise, show a placeholder unknown-location message.
                if let lead {
                    leadContent(lead)
                } else {
                    unknownLocationContent
                }
                
                Spacer()
                
                // Button that returns the player to the museum.
                bottomButtons
            }
            .padding()
        }
        
        // Presents the player's inventory as a medium-height sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
    }
    
    
    // MARK: - Background
    
    /// The atmospheric background for the location placeholder.
    ///
    /// This includes:
    /// - a dark blue vertical gradient
    /// - a snowfall overlay
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
            
            // Decorative snow effect.
            // This overlay does not block taps because `SnowfallOverlay`
            // disables hit testing internally.
            SnowfallOverlay()
        }
    }
    
    
    // MARK: - Top Bar
    
    /// The top bar shown at the top of the location screen.
    ///
    /// It displays:
    /// - the location name
    /// - the "Field Investigation" subtitle
    /// - a bag button that opens the inventory sheet
    private var topBar: some View {
        HStack {
            
            // MARK: Location Text
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.displayName)
                    .font(.title2.bold())
                
                Text("Field Investigation")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            
            // MARK: Bag Button
            
            // Opens the inventory sheet.
            Button {
                showingInventory = true
            } label: {
                Label("Bag", systemImage: "backpack.fill")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
        }
    }
    
    
    // MARK: - Lead Content
    
    /// Displays the main investigation content for a known story lead.
    ///
    /// This includes:
    /// - the lead icon
    /// - the lead title
    /// - the lead subtitle
    /// - the public mystery
    /// - the museum curator's note
    /// - either a completed label or a field-notes button
    ///
    /// - Parameter lead: The story lead connected to this location.
    /// - Returns: A view containing the lead's investigation content.
    private func leadContent(_ lead: StoryLead) -> some View {
        VStack(spacing: 18) {
            
            // Large icon representing this lead.
            Image(systemName: lead.systemImage)
                .font(.system(size: 72))
                .foregroundStyle(.orange)
            
            // Main lead title.
            Text(lead.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            // Short subtitle or summary.
            Text(lead.subtitle)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            
            // MARK: Mystery Card
            
            VStack(alignment: .leading, spacing: 12) {
                
                // Public-facing mystery text.
                Text("Public Mystery")
                    .font(.headline)
                    .foregroundStyle(.yellow)
                
                Text(lead.publicMystery)
                    .foregroundStyle(.white.opacity(0.85))
                
                Divider()
                    .background(.white.opacity(0.25))
                
                // Curator note section.
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
            
            
            // MARK: Completion / Field Notes Button
            
            // If this lead has already been completed, show a green status label.
            if gameState.isLeadCompleted(lead) {
                Label("Lead explored", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
            } else {
                
                // Otherwise, allow the player to record field notes.
                //
                // Completing the lead updates `GameState`, which can unlock
                // future leads or progress the story.
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
    
    
    // MARK: - Unknown Location Content
    
    /// The fallback content shown when this location has no story lead.
    ///
    /// This is useful during development when a location exists in the app but
    /// has not yet been connected to a `StoryLead`.
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
    
    
    // MARK: - Bottom Buttons
    
    /// The bottom navigation button for leaving the location.
    ///
    /// Currently, this always returns the player to the museum interior.
    private var bottomButtons: some View {
        Button {
            
            // Move the player back to the museum.
            gameState.currentLocation = .museumInterior
            
        } label: {
            Label("Return to Museum", systemImage: "arrow.uturn.left")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}


// MARK: - Preview

#Preview {
    StoryLocationPlaceholderView(location: .caveAndBasin)
        .environmentObject(GameState())
}
