//
//  BigfootEvidenceCameraView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct BigfootEvidenceCameraView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let onCapture: () -> Void
    
    @State private var hasTakenPhoto = false
    @State private var flashOpacity = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .black,
                    Color(red: 0.08, green: 0.08, blue: 0.10),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if hasTakenPhoto {
                resultView
            } else {
                cameraView
            }
            
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
        }
    }
    
    private var cameraView: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    SoundManager.shared.play(.close, volume: 0.45)
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                Text("EVIDENCE PHOTO")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
            
            Spacer()
            
            ZStack {
                Image("camera_bigfoot_in_lair")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 380)
                    .clipped()
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.05),
                        Color.black.opacity(0.55)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.9), lineWidth: 4)
                
                VStack {
                    Spacer()
                    
                    Text("Bigfoot")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text("For one impossible second, he stands still.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 24)
            .frame(height: 380)
            
            Spacer()
            
            Button {
                takePhoto()
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 82, height: 82)
                    
                    Circle()
                        .stroke(.black.opacity(0.35), lineWidth: 4)
                        .frame(width: 68, height: 68)
                }
            }
            .padding(.bottom, 36)
        }
    }
    
    private var resultView: some View {
        VStack(spacing: 24) {
            Text("Photo Captured")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            VStack(spacing: 14) {
                Image("camera_bigfoot_empty_cave")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 310)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Empty Cave")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text("""
                When the image settles, Bigfoot is gone.

                The cave is empty.

                Only a pale blur of breath hangs near the edge of the frame.
                """)
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.75))
                .multilineTextAlignment(.center)
            }
            .padding(18)
            .background(.white)
            .rotationEffect(.degrees(2))
            .shadow(radius: 16)
            .padding(.horizontal, 32)
            
            Button {
                onCapture()
                SoundManager.shared.play(.close, volume: 0.45)
                dismiss()
            } label: {
                Text("Lower Camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
    
    private func takePhoto() {
        flashOpacity = 1.0
        
        withAnimation(.easeOut(duration: 0.45)) {
            flashOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            hasTakenPhoto = true
        }
    }
}


