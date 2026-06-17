//
//  PocketGoldNuggetOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-17.
//

import SwiftUI

struct PocketGoldNuggetOverlay: View {
    
    let onAddToInventory: () -> Void
    
    @State private var nuggetScale = 0.75
    @State private var nuggetOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.72)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                Text("Something is in your pocket.")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Image("item_lost_lemon_gold_nugget")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 145, height: 145)
                    .scaleEffect(nuggetScale)
                    .opacity(nuggetOpacity)
                    .shadow(color: .yellow.opacity(0.8), radius: 16)
                
                VStack(spacing: 8) {
                    Text("Lost Lemon Gold Nugget")
                        .font(.title2.bold())
                        .foregroundStyle(.yellow)
                    
                    Text("""
                    It is real.

                    Whatever happened beneath Tunnel Mountain, you brought something back.
                    """)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.86))
                    .multilineTextAlignment(.center)
                }
                .opacity(textOpacity)
                
                Button {
                    SoundManager.shared.play(.itemCollect, volume: 0.85)
                    HapticsManager.shared.success()
                    onAddToInventory()
                } label: {
                    Text("Add Nugget to Bag")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            .padding(24)
            .background(Color.black.opacity(0.88))
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .padding(.horizontal, 28)
        }
        .onAppear {
            SoundManager.shared.play(.nuggetReveal, volume: 0.75)
            
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                nuggetScale = 1.0
                nuggetOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                withAnimation(.easeInOut(duration: 0.65)) {
                    textOpacity = 1.0
                }
            }
        }
    }
}
