//
//  BigfootLairBlackoutView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct BigfootLairBlackoutView: View {
    
    let onFinished: () -> Void
    
    @State private var opacity = 0.0
    @State private var messageOpacity = 0.0
    @State private var finalMessageOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(opacity)
                .ignoresSafeArea()
            
            VStack(spacing: 14) {
                
                Text("A low rumble echoes through the cave.")
                    .opacity(messageOpacity)
                
                Text("The Bigfoot family gathers near the mine entrance.")
                    .opacity(messageOpacity)
                
                Text("Something warm and heavy settles around your shoulders.")
                    .opacity(finalMessageOpacity)
                
                Text("The world slips away again.")
                    .opacity(finalMessageOpacity)
            }
            .font(.headline)
            .foregroundStyle(.white.opacity(0.92))
            .multilineTextAlignment(.center)
            .padding()
        }
        .onAppear {
            SoundManager.shared.play(.blackoutRumble, volume: 0.65)
            withAnimation(.easeInOut(duration: 2.0)) {
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    messageOpacity = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                withAnimation(.easeInOut(duration: 1.8)) {
                    finalMessageOpacity = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                onFinished()
            }
        }
    }
}
