//
//  HotspotButton.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct HotspotButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void
    
    @State private var pulse = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .stroke(color.opacity(0.65), lineWidth: 3)
                        .frame(width: pulse ? 62 : 46, height: pulse ? 62 : 46)
                        .opacity(pulse ? 0.15 : 0.8)
                    
                    Circle()
                        .fill(color.opacity(0.95))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: systemImage)
                        .font(.headline)
                        .foregroundStyle(.black.opacity(0.8))
                }
                
                Text(title)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.45))
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
            ) {
                pulse = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        HotspotButton(
            title: "Mailbox",
            systemImage: "envelope.fill",
            color: .red,
            action: {}
        )
    }
}
