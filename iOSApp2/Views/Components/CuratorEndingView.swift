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
    
    @State private var answer = ""
    @State private var resultMessage: String?
    
    private var foundAllPhotos: Bool {
        gameState.photoCount == gameState.totalPhotoCount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.10, green: 0.08, blue: 0.05),
                    Color.black
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
                        fullPhotoEnding
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
            
            Text(gameState.discoveredCuratorLetters)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .tracking(8)
                .foregroundStyle(.yellow)
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
            
            Text("Who guards the Lost Lemon Mine?")
                .font(.headline)
                .foregroundStyle(.white)
            
            TextField("Type your answer", text: $answer)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            
            Button {
                submitAnswer()
            } label: {
                Text("Submit Answer")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            if let resultMessage {
                Text(resultMessage)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button {
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
                dismiss()
            } label: {
                Text("Keep Exploring")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
    
    private func submitAnswer() {
        if gameState.isCuratorAnswerCorrect(answer) {
            resultMessage = """
            “Sasquatch,” the curator whispers.

            The museum has its story.

            Not proof. Not exactly.

            Something better: a legend people will come looking for.
            """
        } else {
            resultMessage = """
            The curator studies the answer, then slowly shakes her head.

            “Not quite. Look again at the letters.”
            """
        }
    }
}

#Preview {
    CuratorEndingView()
}
