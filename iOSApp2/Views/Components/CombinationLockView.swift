//
//  CombinationLockView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct CombinationLockView: View {
    let correctCode: String
    let onUnlock: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var digits: [Int] = [0, 0, 0, 0]
    @State private var message: String = "Enter the four-digit code."
    @State private var isWrongCode: Bool = false
    
    private var enteredCode: String {
        digits.map(String.init).joined()
    }
    
    var body: some View {
        VStack(spacing: 22) {
            Capsule()
                .fill(.secondary.opacity(0.4))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
            
            VStack(spacing: 6) {
                Text("Museum Door Lock")
                    .font(.title2.bold())
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(isWrongCode ? .red : .secondary)
                    .multilineTextAlignment(.center)
            }
            
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
            
            HStack(spacing: 14) {
                Button {
                    dismiss()
                } label: {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    checkCode()
                } label: {
                    Text("Unlock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            Text("Hint: Check the museum curator's mailbox note.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
    }
    
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

#Preview {
    CombinationLockView(
        correctCode: "01885",
        onUnlock: {}
    )
}
