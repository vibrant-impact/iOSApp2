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
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                onIncrement()
            } label: {
                Image(systemName: "chevron.up")
                    .font(.headline.bold())
            }
            
            Text("\(value)")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .frame(width: 48, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.85))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.25), lineWidth: 2)
                }
                .foregroundStyle(.white)
            
            Button {
                onDecrement()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.headline.bold())
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LockDial(
        value: 8,
        onIncrement: {},
        onDecrement: {}
    )
    .padding()
}
