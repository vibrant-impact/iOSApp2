//
//  IcicleFallSequenceView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct IcicleFallSequenceView: View {
    
    let onFinished: () -> Void
    
    @State private var icicleY: CGFloat = -420
    @State private var icicleX: CGFloat = 0
    @State private var icicleRotation: Double = -8
    @State private var icicleOpacity = 0.0
    
    @State private var sceneScale = 1.0
    @State private var sceneShakeX: CGFloat = 0
    @State private var sceneShakeY: CGFloat = 0
    
    @State private var impactFlashOpacity = 0.0
    @State private var blackoutOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // MARK: Scene Content
                
                ZStack {
                    Image("tunnel_mountain_cave_break_sequence")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()
                    
                    Color.black
                        .opacity(0.12)
                        .ignoresSafeArea()
                    
                    Image("falling_icicle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.18, 110))
                        .rotationEffect(.degrees(icicleRotation))
                        .offset(x: icicleX, y: icicleY)
                        .opacity(icicleOpacity)
                        .shadow(color: .white.opacity(0.7), radius: 8)
                }
                .scaleEffect(sceneScale)
                .offset(x: sceneShakeX, y: sceneShakeY)
                
                // MARK: Impact Flash
                
                Color.white
                    .opacity(impactFlashOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                // MARK: Blackout
                
                Color.black
                    .opacity(blackoutOpacity)
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Text("The boards split with a sharp crack.")
                    Text("Something above you gives way.")
                    Text("Then everything goes black.")
                }
                .font(.headline)
                .foregroundStyle(.white.opacity(0.94))
                .multilineTextAlignment(.center)
                .padding()
                .opacity(textOpacity)
            }
            .onAppear {
                runSequence(screenHeight: geometry.size.height)
            }
        }
    }
    
    
    // MARK: - Sequence
    
    private func runSequence(screenHeight: CGFloat) {
        
        // Beat 1: pause so the player sees the cave.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.easeInOut(duration: 0.25)) {
                icicleOpacity = 1.0
            }
        }
        
        // Beat 2: icicle drops.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
            withAnimation(.easeIn(duration: 0.55)) {
                icicleY = screenHeight * 0.50
                icicleX = -18
                icicleRotation = 18
            }
        }
        
        // Beat 3: impact flash.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.63) {
            withAnimation(.linear(duration: 0.04)) {
                impactFlashOpacity = 1.0
                sceneScale = 1.06
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.78) {
            withAnimation(.easeOut(duration: 0.38)) {
                impactFlashOpacity = 0.0
            }
        }
        
        // Beat 4: stronger shake.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.64) {
            shakeScene()
        }
        
        // Beat 5: blackout after the player has time to feel the impact.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.15) {
            withAnimation(.easeInOut(duration: 0.75)) {
                blackoutOpacity = 1.0
            }
        }
        
        // Beat 6: text appears after blackout.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.95) {
            withAnimation(.easeInOut(duration: 0.7)) {
                textOpacity = 1.0
            }
        }
        
        // Beat 7: move to lair.
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.8) {
            onFinished()
        }
    }
    
    
    // MARK: - Shake
    
    private func shakeScene() {
        let steps: [(delay: Double, x: CGFloat, y: CGFloat)] = [
            (0.00, -22, 8),
            (0.06, 24, -7),
            (0.12, -18, 6),
            (0.18, 16, -5),
            (0.24, -10, 3),
            (0.30, 7, -2),
            (0.38, 0, 0)
        ]
        
        for step in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + step.delay) {
                withAnimation(.linear(duration: 0.055)) {
                    sceneShakeX = step.x
                    sceneShakeY = step.y
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            withAnimation(.easeOut(duration: 0.25)) {
                sceneScale = 1.0
            }
        }
    }
}
