//
//  EndingSubmissionView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// A results screen where the player submits their final scavenger hunt progress.
///
/// This view shows:
/// - how many photo symbols the player found
/// - the reward or discount code earned from photo progress
/// - the secret letters discovered from photographed symbols
/// - a text field for entering the curator's name
/// - the final game ending after submission
///
/// The ending is calculated by `GameState` using the player's progress and
/// the curator name answer.
struct EndingSubmissionView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This provides photo progress, reward information, discovered letters,
    /// and ending calculation logic.
    @EnvironmentObject private var gameState: GameState
    
    /// Allows this view to dismiss itself and return to the game.
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - State
    
    /// The player's typed answer for the curator name puzzle.
    ///
    /// The correct answer is checked inside `GameState.ending(for:)`.
    @State private var curatorAnswer = ""
    
    /// Tracks whether the player has pressed the submit button.
    ///
    /// The ending card only appears after this becomes `true`.
    @State private var hasSubmitted = false
    
    
    // MARK: - Computed Properties
    
    /// The ending the player earns based on current progress and typed answer.
    ///
    /// This value updates automatically whenever `curatorAnswer` changes or
    /// when relevant game progress changes in `GameState`.
    private var ending: GameEnding {
        gameState.ending(for: curatorAnswer)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    
                    // Shows photo symbol progress and the reward code.
                    progressCard
                    
                    // Shows the curator name puzzle and answer field.
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
            .navigationTitle("Submit Results")
        }
    }
    
    
    // MARK: - Progress Card
    
    /// Shows the player's photo scavenger hunt progress.
    ///
    /// This card includes:
    /// - the number of photographed symbols
    /// - the total number of possible symbols
    /// - the reward message
    /// - the reward or discount code
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Photo Scavenger Hunt")
                .font(.title2.bold())
            
            Text("Historical symbols photographed:")
                .foregroundStyle(.secondary)
            
            // Large visual count of collected symbols.
            Text("\(gameState.photographedSymbolCount) / \(gameState.totalPhotoSymbolCount)")
                .font(.largeTitle.bold())
            
            Divider()
            
            // Message based on how many photo symbols have been collected.
            Text(gameState.photoRewardMessage)
                .font(.headline)
            
            HStack {
                Text("Discount Code:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                // Shows either a real reward code or "LOCKED".
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
    
    /// Shows the curator name puzzle.
    ///
    /// Each photographed `PhotoSymbol` reveals one secret letter.
    /// The player uses the discovered letters to guess the curator's name.
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
                
                // Shows discovered secret letters.
                //
                // If no letters have been found yet, the player sees "None".
                Text(gameState.discoveredCuratorLetters.isEmpty ? "None" : gameState.discoveredCuratorLetters)
                    .font(.headline.monospaced())
                    .foregroundStyle(.red)
            }
            
            // Text field where the player enters the curator's name.
            //
            // Capitalization is set to characters to make puzzle entry easier,
            // and autocorrection is disabled so the system does not alter names.
            TextField("Curator name", text: $curatorAnswer)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            // Extra grand prize instruction appears only after all symbols are found.
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
    
    
    // MARK: - Ending Card
    
    /// Shows the final ending after the player submits their results.
    ///
    /// The ending depends on:
    /// - photo symbol progress
    /// - evidence progress
    /// - whether the curator name answer is correct
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
