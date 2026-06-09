//
//  EvidenceListView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// Displays all evidence the player has collected during the investigation.
///
/// This view works like the player's evidence journal.
/// As the player explores locations and records important clues, those clues
/// are added to `GameState.collectedEvidence`.
///
/// If no evidence has been collected yet, the view shows an empty-state message.
/// If evidence exists, the view lists each clue with an icon, name, and description.
struct EvidenceListView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This provides access to:
    /// - collected evidence
    /// - evidence names
    /// - evidence descriptions
    /// - evidence icon names
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                
                // If the player has not collected any evidence yet,
                // show a friendly empty-state message instead of a blank list.
                if gameState.collectedEvidence.isEmpty {
                    emptyEvidenceView
                } else {
                    evidenceRows
                }
            }
            .navigationTitle("Evidence")
        }
    }
    
    
    // MARK: - Empty Evidence View
    
    /// The message shown when the player has not collected evidence yet.
    ///
    /// This helps explain what the player should do next instead of leaving
    /// the evidence list empty.
    private var emptyEvidenceView: some View {
        VStack(spacing: 12) {
            
            // Large detective-style document icon.
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            
            Text("No Evidence Yet")
                .font(.headline)
            
            Text("Explore the museum curator's leads and record field notes to begin connecting the mysteries.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    
    // MARK: - Evidence Rows
    
    /// Displays one row for each collected evidence item.
    ///
    /// Each row includes:
    /// - an SF Symbol icon
    /// - the evidence name
    /// - the evidence description
    private var evidenceRows: some View {
        ForEach(gameState.collectedEvidence) { evidence in
            HStack(alignment: .top, spacing: 12) {
                
                // Icon representing the type of evidence.
                Image(systemName: evidence.systemImage)
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    // Main evidence title.
                    Text(evidence.name)
                        .font(.headline)
                    
                    // Short explanation of why this clue matters.
                    Text(evidence.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 6)
        }
    }
}


// MARK: - Preview

#Preview {
    EvidenceListView()
        .environmentObject(GameState())
}
