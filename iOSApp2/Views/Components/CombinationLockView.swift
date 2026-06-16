//
//  CombinationLockView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A modal view that shows a four-digit combination lock.
struct CombinationLockView: View {

    let correctCode: String
    let onUnlock: () -> Void
    
    // MARK: - Environment
    
    /// Allows this sheet or modal view to close itself.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    /// The default value is `0000`.
    @State private var digits: [Int] = [0, 0, 0, 0]
    @State private var message: String = "Enter the four-digit code."
    @State private var isWrongCode: Bool = false
    
    // MARK: - Computed Properties
    
    /// Converts the four dial values into a single code string.
    private var enteredCode: String {
        digits.map(String.init).joined()
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 22) {
            
            // Small capsule handle at the top of the sheet.
            // This visually suggests that the view can be dismissed.
            Capsule()
                .fill(.secondary.opacity(0.4))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
            
            // MARK: Title and Status Message
            
            VStack(spacing: 6) {
                Text("Museum Door Lock")
                    .font(.title2.bold())
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(isWrongCode ? .red : .secondary)
                    .multilineTextAlignment(.center)
            }
            
            // MARK: Lock Dials
            
            /// Creates four lock dials, one for each digit in the code.
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    LockDial(
                        value: digits[index],
                        onIncrement: {
                            digits[index] = (digits[index] + 1) % 10
                        },
                        onDecrement: {
                            digits[index] = (digits[index] + 9) % 10
                        }
                    )
                }
            }
            .padding(.vertical, 6)
            
            
            // MARK: Buttons
            
            HStack(spacing: 14) {
                
                // Closes the lock view without changing game progress.
                Button {
                    SoundManager.shared.play(.close, volume: 0.45)
                    dismiss()
                } label: {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                // Checks whether the entered code matches the correct code.
                Button {
                    checkCode()
                } label: {
                    Text("Unlock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            
            // MARK: Hint Text
            
            // Gives the player a reminder about where to find the code clue.
            Text("Hint: History holds the key.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
    }
    
    
    // MARK: - Code Checking
    
    /// Checks whether the player's entered code matches the correct code.
    private func checkCode() {
        if enteredCode == correctCode {
            isWrongCode = false
            message = "The lock clicks open."
            onUnlock()
        } else {
            isWrongCode = true
            message = "That combination does not work."
        }
    }
}


// MARK: - Preview

#Preview {
    CombinationLockView(
        correctCode: "1903",
        onUnlock: {}
    )
}
