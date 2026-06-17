//
//  LetterScrapPuzzleView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-16.
//

import SwiftUI

struct LetterScrapPuzzleView: View {
    
    let letters: String
    let solution: String
    let onSolved: () -> Void
    let onWrongAnswer: () -> Void
    
    @State private var availableTiles: [PuzzleLetterTile] = []
    @State private var answerSlots: [PuzzleLetterTile?] = []
    @State private var selectedTileID: UUID?
    @State private var message: String?
    
    private var currentAnswer: String {
        answerSlots
            .compactMap { $0?.letter }
            .joined()
    }
    
    private var isComplete: Bool {
        !answerSlots.isEmpty && answerSlots.allSatisfy { $0 != nil }
    }
    
    var body: some View {
        VStack(spacing: 18) {
            
            availableLettersArea
            
            Text("Arrange the letter scraps.")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Tap a scrap, then tap a space.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            answerLine
            
            Button {
                submit()
            } label: {
                Text("Submit Answer")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isComplete)
            .opacity(isComplete ? 1.0 : 0.55)
            .padding(.horizontal)
            
            Button {
                resetPuzzle()
            } label: {
                Text("Reset Scraps")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            
            if let message {
                Text(message)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            if availableTiles.isEmpty && answerSlots.isEmpty {
                setupTiles()
            }
        }
    }
    
    
    // MARK: - Answer Line
    
    private var answerLine: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 4
            let slotCount = max(solution.count, 1)
            let totalSpacing = spacing * CGFloat(max(slotCount - 1, 0))
            let availableWidth = geometry.size.width - totalSpacing
            let tileSize = min(38, availableWidth / CGFloat(slotCount))
            
            HStack(spacing: spacing) {
                ForEach(answerSlots.indices, id: \.self) { index in
                    answerSlot(index: index, tileSize: tileSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
    }
    
    private func answerSlot(index: Int, tileSize: CGFloat) -> some View {
        Button {
            handleSlotTapped(index)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                
                if let tile = answerSlots[index] {
                    LetterScrapTileView(
                        tile: tile,
                        size: tileSize,
                        isSelected: selectedTileID == tile.id
                    )
                }
            }
            .frame(width: tileSize, height: tileSize)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    
    // MARK: - Available Letters
    
    private var availableLettersArea: some View {
        VStack(spacing: 10) {
            Text("Letter Scraps")
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.72))
            
            GeometryReader { geometry in
                let spacing: CGFloat = 6
                let tileCount = max(availableTiles.count, 1)
                let totalSpacing = spacing * CGFloat(max(tileCount - 1, 0))
                let availableWidth = geometry.size.width - totalSpacing
                let tileSize = min(42, availableWidth / CGFloat(tileCount))
                
                HStack(spacing: spacing) {
                    ForEach(availableTiles) { tile in
                        Button {
                            handleAvailableTileTapped(tile)
                        } label: {
                            LetterScrapTileView(
                                tile: tile,
                                size: tileSize,
                                isSelected: selectedTileID == tile.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 56)
            .padding(10)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal)
        }
    }
    
    
    // MARK: - Setup
    
    private func setupTiles() {
        let discoveredLetters = Array(letters.uppercased())
        var letterCounts: [String: Int] = [:]
        
        availableTiles = discoveredLetters.map { character in
            let letter = String(character)
            let occurrence = (letterCounts[letter] ?? 0) + 1
            letterCounts[letter] = occurrence
            
            return PuzzleLetterTile(
                letter: letter,
                imageName: imageName(for: letter, occurrence: occurrence)
            )
        }
        
        answerSlots = Array(repeating: nil, count: solution.count)
        selectedTileID = nil
        message = nil
    }
    
    private func imageName(for letter: String, occurrence: Int) -> String {
        switch letter {
        case "A":
            return "corkboard_letter_a_\(occurrence)"
        case "S":
            return "corkboard_letter_s_\(occurrence)"
        case "C":
            return "corkboard_letter_c"
        case "H":
            return "corkboard_letter_h"
        case "Q":
            return "corkboard_letter_q"
        case "T":
            return "corkboard_letter_t"
        case "U":
            return "corkboard_letter_u"
        default:
            return "corkboard_letter_blank"
        }
    }
    
    
    // MARK: - Tile Interaction
    
    private func handleAvailableTileTapped(_ tile: PuzzleLetterTile) {
        SoundManager.shared.play(.tap, volume: 0.35)
        HapticsManager.shared.lightTap()
        message = nil
        
        if selectedTileID == tile.id {
            selectedTileID = nil
        } else {
            selectedTileID = tile.id
        }
    }
    
    private func handleSlotTapped(_ index: Int) {
        message = nil
        
        if let selectedTileID,
           let availableIndex = availableTiles.firstIndex(where: { $0.id == selectedTileID }) {
            
            SoundManager.shared.play(.paperNote, volume: 0.35)
            HapticsManager.shared.lightTap()
            
            let selectedTile = availableTiles.remove(at: availableIndex)
            
            if let existingTile = answerSlots[index] {
                availableTiles.append(existingTile)
            }
            
            answerSlots[index] = selectedTile
            self.selectedTileID = nil
            return
        }
        
        if let existingTile = answerSlots[index] {
            SoundManager.shared.play(.close, volume: 0.3)
            HapticsManager.shared.lightTap()
            
            answerSlots[index] = nil
            availableTiles.append(existingTile)
            selectedTileID = nil
        }
    }
    
    
    // MARK: - Actions
    
    private func resetPuzzle() {
        SoundManager.shared.play(.close, volume: 0.35)
        HapticsManager.shared.lightTap()
        setupTiles()
    }
    
    private func submit() {
        let normalizedAnswer = currentAnswer
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let normalizedSolution = solution
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if normalizedAnswer == normalizedSolution {
            SoundManager.shared.play(.curatorSuccess, volume: 0.9)
            HapticsManager.shared.success()
            onSolved()
        } else {
            SoundManager.shared.play(.curatorWrong, volume: 0.65)
            HapticsManager.shared.warning()
            message = "Not quite. Try rearranging the letters."
            onWrongAnswer()
        }
    }
}


// MARK: - Puzzle Letter Tile

struct PuzzleLetterTile: Identifiable, Equatable {
    let id = UUID()
    let letter: String
    let imageName: String
}


// MARK: - Letter Scrap Tile View

struct LetterScrapTileView: View {
    
    let tile: PuzzleLetterTile
    let size: CGFloat
    let isSelected: Bool
    
    var body: some View {
        Image(tile.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(isSelected ? 1.12 : 1.0)
            .shadow(
                color: isSelected ? .yellow.opacity(0.85) : .black.opacity(0.28),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 0 : 3
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color.yellow.opacity(0.9) : Color.clear,
                        lineWidth: 2
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
