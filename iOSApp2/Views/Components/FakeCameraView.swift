//
//  FakeCameraView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

struct FakeCameraView: View {
    @Environment(\.dismiss) private var dismiss
    
    let symbol: PhotoSymbol
    let alreadyCaptured: Bool
    let onCapture: (PhotoSymbol) -> Void
    
    @State private var hasTakenPhoto = false
    @State private var flashOpacity = 0.0
    
    private var showingPolaroid: Bool {
        alreadyCaptured || hasTakenPhoto
    }
    
    var body: some View {
        ZStack {
            cameraBackground
            
            if showingPolaroid {
                polaroidResult
            } else {
                cameraInterface
            }
            
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
        }
    }
    
    private var cameraBackground: some View {
        LinearGradient(
            colors: [
                Color.black,
                Color(red: 0.08, green: 0.10, blue: 0.13),
                Color.black
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var cameraInterface: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                Text("PHOTO CLUE")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.85), lineWidth: 4)
                    .frame(height: 360)
                    .overlay {
                        VStack(spacing: 16) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 70))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text(symbol.symbolName)
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Frame the symbol and take a photo.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .padding()
                    }
                    .padding(.horizontal, 24)
                
                Text("Location Symbol")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            
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
    
    private var polaroidResult: some View {
        ScrollView {
            VStack(spacing: 22) {
                Text(alreadyCaptured && !hasTakenPhoto ? "Photo Already Collected" : "Photo Captured")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 36)
                
                VStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.88))
                        .frame(height: 310)
                        .overlay {
                            VStack(spacing: 18) {
                                Image(systemName: "camera.macro")
                                    .font(.system(size: 72))
                                    .foregroundStyle(.yellow)
                                
                                Text(symbol.symbolName)
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    
                    Text(symbol.symbolName)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    HStack {
                        Text("Circled letter:")
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                        
                        Text(symbol.secretLetter)
                            .font(.title2.bold())
                            .foregroundStyle(.red)
                            .frame(width: 42, height: 42)
                            .overlay {
                                Circle()
                                    .stroke(.red, lineWidth: 3)
                            }
                    }
                }
                .padding(18)
                .background(.white)
                .rotationEffect(.degrees(-2))
                .shadow(radius: 16)
                .padding(.horizontal, 32)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Historical Note")
                        .font(.headline)
                        .foregroundStyle(.yellow)
                    
                    Text(symbol.historicalNote)
                        .foregroundStyle(.white.opacity(0.88))
                    
                    Text("Letters found so far can help reveal the curator’s name.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 4)
                }
                .padding()
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
                
                Button {
                    dismiss()
                } label: {
                    Text("Keep Exploring")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func takePhoto() {
        flashOpacity = 1.0
        
        withAnimation(.easeOut(duration: 0.45)) {
            flashOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onCapture(symbol)
            hasTakenPhoto = true
        }
    }
}

#Preview {
    FakeCameraView(
        symbol: .caveAndBasin,
        alreadyCaptured: false,
        onCapture: { _ in }
    )
}
