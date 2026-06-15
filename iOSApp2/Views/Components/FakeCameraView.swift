//
//  FakeCameraView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// A fake in-game camera screen used for taking photos.
struct FakeCameraView: View {
    
    /// Allows this camera screen to close itself.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Input Properties

    let photo: Photo
    let alreadyCaptured: Bool
    let onCapture: (Photo) -> Void
    
    // MARK: - State
    
    /// Tracks whether the player has taken a photo during this camera session.
    @State private var hasTakenPhoto = false
    
    /// Controls the opacity of the white camera flash overlay.
    /// The value briefly jumps to `1.0`, then animates back to `0.0`.
    @State private var flashOpacity = 0.0
    
    // MARK: - Computed Properties
    
    /// Determines whether the Polaroid result should be displayed.
    private var showingPolaroid: Bool {
        alreadyCaptured || hasTakenPhoto
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Dark full-screen background for the camera view.
            cameraBackground
            
            // Switches between the fake camera interface and the captured result.
            if showingPolaroid {
                polaroidResult
            } else {
                cameraInterface
            }
            
            // White overlay used to create a camera flash effect.
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
        }
        
        
    }
    
    
    // MARK: - Camera Background
    
    /// The dark gradient background behind the camera interface.
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
    
    // MARK: - Viewfinder Image

    private var viewfinderImage: some View {
        GeometryReader { geometry in
            ZStack {
                Image(photo.cameraImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.10),
                        Color.black.opacity(0.05),
                        Color.black.opacity(0.62)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    
                    VStack(spacing: 0) {
                        Image(systemName: "viewfinder")
                            .font(.system(size: 100))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.85), lineWidth: 4)
            }
        }
        .frame(height: 360)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Camera Interface
    
    /// The fake camera screen shown before the photo is taken.
    private var cameraInterface: some View {
        VStack(spacing: 24) {
            
            // MARK: Top Bar
            
            HStack {
                
                // Closes the camera without taking a photo.
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Small label that identifies this as the photo clue mode.
                Text("PHOTO DOCUMENTATION")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
            
            Spacer()
            
            Text(photo.photoName)
                .font(.title3.bold())
                .foregroundStyle(.white)


            // MARK: Viewfinder

            VStack(spacing: 12) {
                viewfinderImage
                
                Text("Snap the Pic")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            
            Spacer()
            
            // MARK: Shutter Button
            
            /// Fake camera shutter button.
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
    
    // MARK: - Polaroid Photo Image

    private var polaroidPhotoImage: some View {
        GeometryReader { geometry in
            ZStack {
                Image(photo.cameraImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.05),
                        Color.black.opacity(0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    Spacer()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 310)
    }
    
    // MARK: - Polaroid Result
    
    /// The captured-photo result screen.
    private var polaroidResult: some View {
        ScrollView {
    
            Spacer()
            
            VStack(spacing: 22) {
                HStack {
                
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding()
                    
                    // The title changes depending on whether this is a newly
                    // captured photo or a previously collected one.
                    Text(alreadyCaptured && !hasTakenPhoto ? "Photo Already Collected" : "Photo Captured")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    // Closes the camera without taking a photo.
                    Spacer()
                }
                .padding()
                
                // MARK: Polaroid Card
                
                VStack(spacing: 14) {
                    
                    polaroidPhotoImage
                    
                    // Polaroid caption.
                    Text(photo.photoName)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    // Reveals the secret letter from this photo.
                    HStack {
                        Text("CLUE:")
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                        
                        Text(photo.secretLetter)
                            .font(.title2.bold())
                            .foregroundStyle(.red)
                            .frame(width: 42, height: 42)
                            .overlay {
                                
                                // Red circle to make the secret letter feel
                                // like a marked clue in a photograph.
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
                
                
                // MARK: Historical Note Card
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Historical Relevance")
                        .font(.headline)
                        .foregroundStyle(.yellow)
                    
                    Text(photo.historicalNote)
                        .foregroundStyle(.white.opacity(0.88))
                    
                    Text("Find all the clues to answer the curator's question.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 4)
                }
                .padding()
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
            }
        }
    }
    
    
    // MARK: - Photo Capture Logic
    
    /// Handles the fake photo-taking sequence.
    private func takePhoto() {
        
        // Instantly show the flash.
        flashOpacity = 1.0
        
        // Fade the flash away.
        withAnimation(.easeOut(duration: 0.45)) {
            flashOpacity = 0.0
        }
        
        // Delay slightly so the capture feels like it happens after the shutter.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onCapture(photo)
            hasTakenPhoto = true
        }
    }
}


// MARK: - Preview

#Preview {
    FakeCameraView(
        photo: .caveAndBasin,
        alreadyCaptured: false,
        onCapture: { _ in }
    )
}
