//
//  EndingSubmissionView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// A results screen where the player submits their final scavenger hunt progress.
struct EndingSubmissionView: View {

    @EnvironmentObject private var gameState: GameState
    
    /// Allows this view to dismiss itself and return to the game.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    /// The player's typed answer for the curator puzzle.
    @State private var curatorAnswer = ""
    @State private var hasSubmitted = false
    
    // MARK: - Computed Properties
    
    /// The ending the player earns based on current progress and typed answer.
    private var ending: GameEnding {
        gameState.ending(for: curatorAnswer)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    
                    // Shows photo progress and the reward code.
                    progressCard
                    
                    // Shows the curator puzzle and answer field.
                    curatorCard
                    
                    // Shows the final ending only after the player submits.
                    if hasSubmitted {
                        endingCard
                    }
                    
                    // Submits the player's current results.
                    //
                    // This does not actually send data to a server yet.
                    // It simply reveals the calculated ending.
                    Button {
                        hasSubmitted = true
                    } label: {
                        Label("Submit Results Online", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Closes the submission screen and returns to the game.
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
            .navigationTitle("Summary")
        }
    }
    
    
    // MARK: - Progress Card
    
    /// Shows the player's photo scavenger hunt progress.
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Photo Scavenger Hunt")
                .font(.title2.bold())
            
            Text("Historical photos captured:")
                .foregroundStyle(.secondary)
            
            // Large visual count of collected photos.
            Text("\(gameState.photoCount) / \(gameState.totalPhotoCount)")
                .font(.largeTitle.bold())
            
            Divider()
            
            // Message based on how many photos have been taken.
            Text(gameState.photoRewardMessage)
                .font(.headline)
            
            HStack {
                Text("Discount Code:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                // Shows either a reward code or "LOCKED".
                //
                // If the reward is still locked, the text is gray.
                // If a reward code has been earned, the text turns green.
                Text(gameState.photoRewardCode)
                    .font(.title3.bold())
                    .foregroundColor(gameState.photoRewardCode == "LOCKED" ? Color.secondary : Color.green)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    
    // MARK: - Curator Puzzle Card
    
    /// Shows the curator puzzle.
    private var curatorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Grand Prize Clue")
                .font(.title3.bold())
            
            Text("Each photo contains one red-circled letter. Arrange the letters to solve the curator’s puzzle: Who guards the Lost Lemon Mine?")
                .foregroundStyle(.secondary)
            
            HStack {
                Text("Letters found:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                // Shows discovered secret letters.
                //
                // If no letters have been found yet, the player sees "None".
                Text(gameState.discoveredCuratorLetters.isEmpty ? "None" : gameState.discoveredCuratorLetters)
                    .font(.headline.monospaced())
                    .foregroundStyle(.red)
            }
            
            // Text field where the player enters the answer.
            //
            // Capitalization is set to characters to make puzzle entry easier,
            // and autocorrection is disabled so the system does not alter names.
            TextField("Puzzle Solution", text: $curatorAnswer)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            // Extra grand prize instruction appears only after all photos are found.
            if gameState.photoCount == 9 {
                Text("Find and unscramble all 9 letters and enter the correct curator's puzzle answer to qualify for the $5000 grand prize draw.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    
    // MARK: - Ending Card
    
    /// Shows the final ending after the player submits their results.
    private var endingCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Ending title, such as "The Museum Is Saved".
            Text(ending.title)
                .font(.title.bold())
            
            // Story description explaining the outcome.
            Text(ending.description)
                .foregroundStyle(.secondary)
            
            // Special label for the best ending.
            //
            // This tells the player they unlocked the grand prize draw entry.
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


// MARK: - Preview

#Preview {
    EndingSubmissionView()
        .environmentObject(GameState())
}
