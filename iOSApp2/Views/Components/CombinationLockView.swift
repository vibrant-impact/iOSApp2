//
//  CombinationLockView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A modal view that shows a four-digit combination lock.
///
/// This view is used when the player tries to unlock the museum door.
/// The player changes each digit using individual `LockDial` controls.
/// When the entered code matches `correctCode`, the view calls `onUnlock`.
struct CombinationLockView: View {
    
    /// The correct four-digit code required to unlock the door.
    ///
    /// Example:
    /// `"1885"`
    ///
    /// This is passed in from the parent view so the lock can be reused with
    /// different codes if needed.
    let correctCode: String
    
    /// A closure that runs when the player enters the correct code.
    ///
    /// The parent view usually uses this to update `GameState`, unlock the door,
    /// and move the player into the museum.
    let onUnlock: () -> Void
    
    
    // MARK: - Environment
    
    /// Allows this sheet or modal view to close itself.
    ///
    /// This is used by the Back button.
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - State
    
    /// The current values shown on the four lock dials.
    ///
    /// Each number represents one digit from `0` to `9`.
    /// The default value is `0000`.
    @State private var digits: [Int] = [0, 0, 0, 0]
    
    /// The message shown below the title.
    ///
    /// This changes depending on whether the player has entered the wrong code
    /// or successfully unlocked the door.
    @State private var message: String = "Enter the four-digit code."
    
    /// Tracks whether the most recent code attempt was wrong.
    ///
    /// When this is `true`, the message text turns red.
    @State private var isWrongCode: Bool = false
    
    
    // MARK: - Computed Properties
    
    /// Converts the four dial values into a single code string.
    ///
    /// Example:
    /// If `digits` is `[1, 8, 8, 5]`, this returns `"1885"`.
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
            ///
            /// Each dial can increment or decrement its value.
            /// The modulo math makes the digits wrap around:
            /// - incrementing `9` becomes `0`
            /// - decrementing `0` becomes `9`
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
            Text("Hint: Check the museum curator's mailbox note.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
    }
    
    
    // MARK: - Code Checking
    
    /// Checks whether the player's entered code matches the correct code.
    ///
    /// If the code is correct:
    /// - the error state is cleared
    /// - the success message appears
    /// - `onUnlock` is called
    ///
    /// If the code is wrong:
    /// - the error state is turned on
    /// - the message changes to tell the player the combination failed
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
        correctCode: "1885",
        onUnlock: {}
    )
}
