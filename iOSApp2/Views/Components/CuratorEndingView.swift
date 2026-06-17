//
//  CuratorEndingView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct CuratorEndingView: View {
    
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    @State private var endingPhase: CuratorEndingPhase = .puzzle
    
    private var foundAllPhotos: Bool {
        gameState.photoCount == gameState.totalPhotoCount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 6 / 255, green: 24 / 255, blue: 51 / 255),
                    Color(red: 20/255, green: 82/255, blue: 128/255),
                    Color(red: 6 / 255, green: 24 / 255, blue: 51 / 255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    Text("The Curator's Desk")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.top, 32)
                    
                    Image("ending_curator_at_desk")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .shadow(radius: 16)
                        .padding(.horizontal)
                    
                    if foundAllPhotos {
                        switch endingPhase {
                        case .puzzle:
                            fullPhotoEnding
                        case .rewards:
                            CuratorRewardWrapUpView()
                                .environmentObject(gameState)
                        }
                    } else {
                        incompletePhotoEnding
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    private var fullPhotoEnding: some View {
        VStack(spacing: 18) {
            Text("""
            The curator studies your photographs in silence.

            “You found every missing piece,” she gasps. “Now tell me what the letters reveal.”
            """)
            .foregroundStyle(.white.opacity(0.88))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            LetterScrapPuzzleView(
                letters: gameState.discoveredCuratorLetters,
                solution: "SASQUATCH",
                onSolved: {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            endingPhase = .rewards
                        }
                    }
                },
                onWrongAnswer: {
             
                }
            )
            
            Button {
                SoundManager.shared.play(.close, volume: 0.45)
                dismiss()
            } label: {
                Text("Return to Museum")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
        }
    }

    
    private var incompletePhotoEnding: some View {
        VStack(spacing: 18) {
            Text("""
            The curator listens carefully as you describe the cave, the mine, and the impossible figure in the dark.

            But when she spreads your journal photos across the desk, there are still gaps in the story.
            """)
            .foregroundStyle(.white.opacity(0.88))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Text("Photos Found: \(gameState.photoCount)/\(gameState.totalPhotoCount)")
                .font(.title2.bold())
                .foregroundStyle(.yellow)
            
            Text("""
            Return to Banff and complete the historical photo journal.

            Only then can you solve the curator's final question.
            """)
            .foregroundStyle(.white.opacity(0.8))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Button {
                SoundManager.shared.play(.close, volume: 0.45)
                dismiss()
            } label: {
                Text("Keep Exploring")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
}

private enum CuratorEndingPhase {
    case puzzle
    case rewards
}

#Preview {
    CuratorEndingView()
}
