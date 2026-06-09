//
//  CorkboardView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// Displays the museum curator's corkboard of investigation leads.
///
/// The corkboard acts as the main mission-selection screen inside the museum.
/// It shows the player:
/// - the available story leads
/// - which leads are locked
/// - which leads are completed
/// - how many total leads have been explored
///
/// Leads are grouped by `StoryLeadPhase`:
/// - first leads
/// - second leads
/// - final leads
///
/// The view reads progress from `GameState`.
struct CorkboardView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This provides:
    /// - the list of story leads
    /// - completed lead ids
    /// - lead unlock logic
    /// - lead selection behavior
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                
                // Top corkboard title, instructions, and progress count.
                header
                
                // First investigation phase.
                phaseSection(.first)
                
                // Second investigation phase, unlocked after early progress.
                phaseSection(.second)
                
                // Final investigation phase, unlocked near the end.
                phaseSection(.final)
            }
            .padding()
        }
        .background(
            
            // Brown rounded background to make the view look like a corkboard.
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.30, green: 0.17, blue: 0.08))
                .overlay {
                    
                    // Subtle orange border around the corkboard.
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.orange.opacity(0.35), lineWidth: 2)
                }
        )
    }
    
    
    // MARK: - Header
    
    /// The top section of the corkboard.
    ///
    /// This includes:
    /// - a red pin icon
    /// - the corkboard title
    /// - a short instruction line
    /// - the current lead progress count
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                // Decorative pin icon.
                Image(systemName: "pin.fill")
                    .foregroundStyle(.red)
                
                Text("The museum curator's Corkboard")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            Text("Follow every lead in a group to unlock the next pattern.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
            
            progressText
        }
    }
    
    
    // MARK: - Progress Text
    
    /// Shows how many story leads the player has completed.
    ///
    /// Example:
    /// `"Leads explored: 2 / 7"`
    ///
    /// This helps the player understand overall investigation progress.
    private var progressText: some View {
        let completed = gameState.completedLeadIDs.count
        let total = gameState.storyLeads.count
        
        return Text("Leads explored: \(completed) / \(total)")
            .font(.caption.bold())
            .foregroundStyle(.yellow.opacity(0.9))
            .padding(.top, 2)
    }
    
    
    // MARK: - Phase Section
    
    /// Builds one section of the corkboard for a specific story phase.
    ///
    /// Each phase section includes:
    /// - the phase title
    /// - a locked label if none of the leads in that phase are available
    /// - a locked message if needed
    /// - one `LeadCardView` for each lead in that phase
    ///
    /// - Parameter phase: The `StoryLeadPhase` to display.
    /// - Returns: A section view containing all leads for that phase.
    private func phaseSection(_ phase: StoryLeadPhase) -> some View {
        
        // Gets only the leads that belong to this phase.
        let leads = gameState.storyLeads.filter { $0.phase == phase }
        
        // A phase is considered unlocked if at least one lead in that phase
        // is currently unlocked.
        let phaseUnlocked = leads.contains { gameState.isLeadUnlocked($0) }
        
        return VStack(alignment: .leading, spacing: 10) {
            
            // MARK: Phase Header
            
            HStack {
                Text(phase.title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                // Shows a small lock label when the whole phase is unavailable.
                if !phaseUnlocked {
                    Label("Locked", systemImage: "lock.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.55))
                }
            }
            
            // Shows the phase-specific unlock requirement.
            if !phaseUnlocked && !phase.lockedMessage.isEmpty {
                Text(phase.lockedMessage)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            
            
            // MARK: Lead Cards
            
            // Displays one card for every lead in this phase.
            ForEach(leads) { lead in
                LeadCardView(
                    lead: lead,
                    
                    // Controls whether the card appears active or disabled.
                    isUnlocked: gameState.isLeadUnlocked(lead),
                    
                    // Controls whether the card appears completed.
                    isCompleted: gameState.isLeadCompleted(lead),
                    
                    // Runs when the player taps the lead card.
                    // `GameState` decides what happens next.
                    action: {
                        gameState.selectLead(lead)
                    }
                )
            }
        }
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        
        // Dark background so the brown corkboard stands out.
        Color.black.ignoresSafeArea()
        
        CorkboardView()
            .environmentObject(GameState())
            .padding()
    }
}
