//
//  IcicleFallSequenceView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct IcicleFallSequenceView: View {
    
    let onFinished: () -> Void
    
    @State private var icicleOffset: CGFloat = -260
    @State private var icicleRotation: Double = -8
    @State private var blackoutOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        ZStack {
            Image("tunnel_mountain_cave_break_sequence")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("falling_icicle")
                .resizable()
                .scaledToFit()
                .frame(width: 220)
                .rotationEffect(.degrees(icicleRotation))
                .offset(y: icicleOffset)
                .shadow(color: .white.opacity(0.8), radius: 8)
            
            Color.black
                .opacity(blackoutOpacity)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("The boards split with a sharp crack.")
                Text("Something above you gives way.")
                Text("Then everything goes black.")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding()
            .opacity(textOpacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.55)) {
                icicleOffset = 260
                icicleRotation = 16
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                withAnimation(.easeInOut(duration: 0.45)) {
                    blackoutOpacity = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                withAnimation(.easeInOut(duration: 0.45)) {
                    textOpacity = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onFinished()
            }
        }
    }
}
