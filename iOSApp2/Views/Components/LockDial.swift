//
//  LockDial.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct LockDial: View {
    
    let value: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            
            // MARK: Increment Button
            
            // Moves the dial upward.
            Button {
                onIncrement()
            } label: {
                Image(systemName: "chevron.up")
                    .font(.headline.bold())
            }
            
            // MARK: Current Value Display
            
            // Shows the current digit in a dark rounded rectangle,
            // similar to a physical combination lock window.
            Text("\(value)")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .frame(width: 48, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.85))
                )
                .overlay {
                    
                    // Subtle border around the number window.
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.25), lineWidth: 2)
                }
                .foregroundStyle(.white)
            
            
            // MARK: Decrement Button
            
            // Moves the dial downward.
            Button {
                onDecrement()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.headline.bold())
            }
        }
        
        // Removes default button styling from both chevron buttons so they look
        // like simple lock controls.
        .buttonStyle(.plain)
    }
}


// MARK: - Preview

#Preview {
    LockDial(
        value: 8,
        onIncrement: {},
        onDecrement: {}
    )
    .padding()
}
