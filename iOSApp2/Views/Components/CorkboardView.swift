//
//  CorkboardView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct CorkboardView: View {
    @EnvironmentObject private var gameState: GameState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                
                phaseSection(.first)
                
                phaseSection(.second)
                
                phaseSection(.final)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.30, green: 0.17, blue: 0.08))
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.orange.opacity(0.35), lineWidth: 2)
                }
        )
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
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
    
    private var progressText: some View {
        let completed = gameState.completedLeadIDs.count
        let total = gameState.storyLeads.count
        
        return Text("Leads explored: \(completed) / \(total)")
            .font(.caption.bold())
            .foregroundStyle(.yellow.opacity(0.9))
            .padding(.top, 2)
    }
    
    private func phaseSection(_ phase: StoryLeadPhase) -> some View {
        let leads = gameState.storyLeads.filter { $0.phase == phase }
        let phaseUnlocked = leads.contains { gameState.isLeadUnlocked($0) }
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(phase.title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                if !phaseUnlocked {
                    Label("Locked", systemImage: "lock.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.55))
                }
            }
            
            if !phaseUnlocked && !phase.lockedMessage.isEmpty {
                Text(phase.lockedMessage)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            
            ForEach(leads) { lead in
                LeadCardView(
                    lead: lead,
                    isUnlocked: gameState.isLeadUnlocked(lead),
                    isCompleted: gameState.isLeadCompleted(lead),
                    action: {
                        gameState.selectLead(lead)
                    }
                )
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        CorkboardView()
            .environmentObject(GameState())
            .padding()
    }
}
