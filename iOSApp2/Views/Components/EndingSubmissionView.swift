//
//  EndingSubmissionView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct EndingSubmissionView: View {
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    @State private var curatorAnswer = ""
    @State private var hasSubmitted = false
    
    private var ending: GameEnding {
        gameState.ending(for: curatorAnswer)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    progressCard
                    
                    curatorCard
                    
                    if hasSubmitted {
                        endingCard
                    }
                    
                    Button {
                        hasSubmitted = true
                    } label: {
                        Label("Submit Results Online", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Return to Game")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Submit Results")
        }
    }
    
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photo Scavenger Hunt")
                .font(.title2.bold())
            
            Text("Historical symbols photographed:")
                .foregroundStyle(.secondary)
            
            Text("\(gameState.photographedSymbolCount) / \(gameState.totalPhotoSymbolCount)")
                .font(.largeTitle.bold())
            
            Divider()
            
            Text(gameState.photoRewardMessage)
                .font(.headline)
            
            HStack {
                Text("Discount Code:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                Text(gameState.photoRewardCode)
                    .font(.title3.bold())
                    .foregroundColor(gameState.photoRewardCode == "LOCKED" ? Color.secondary : Color.green)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var curatorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Grand Prize Clue")
                .font(.title3.bold())
            
            Text("Each photo contains one red-circled letter. Arrange the letters to reveal the curator’s name.")
                .foregroundStyle(.secondary)
            
            HStack {
                Text("Letters found:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                Text(gameState.discoveredCuratorLetters.isEmpty ? "None" : gameState.discoveredCuratorLetters)
                    .font(.headline.monospaced())
                    .foregroundStyle(.red)
            }
            
            TextField("Curator name", text: $curatorAnswer)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            if gameState.photographedSymbolCount == 10 {
                Text("Find all 10 symbols and enter the correct curator name to qualify for the $5000 grand prize draw.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var endingCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(ending.title)
                .font(.title.bold())
            
            Text(ending.description)
                .foregroundStyle(.secondary)
            
            if ending == .legendaryLegacy {
                Label("Grand Prize Draw Entry Unlocked", systemImage: "star.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    EndingSubmissionView()
        .environmentObject(GameState())
}
