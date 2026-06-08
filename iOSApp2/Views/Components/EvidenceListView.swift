//
//  EvidenceListView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct EvidenceListView: View {
    @EnvironmentObject private var gameState: GameState
    
    var body: some View {
        NavigationStack {
            List {
                if gameState.collectedEvidence.isEmpty {
                    VStack(spacing: 12) {
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
                } else {
                    ForEach(gameState.collectedEvidence) { evidence in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: evidence.systemImage)
                                .font(.title2)
                                .foregroundStyle(.orange)
                                .frame(width: 32)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(evidence.name)
                                    .font(.headline)
                                
                                Text(evidence.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Evidence")
        }
    }
}

#Preview {
    EvidenceListView()
        .environmentObject(GameState())
}
