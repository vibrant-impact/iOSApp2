//
//  FakeCameraView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// A fake in-game camera screen used for photographing hidden photo symbols.
///
/// This view does not use the real device camera.
/// Instead, it creates a camera-like interface for the scavenger hunt mechanic.
///
/// The player can:
/// - view a fake camera frame
/// - tap a shutter button
/// - see a flash effect
/// - receive a Polaroid-style result
/// - reveal the symbol's secret letter
/// - read the historical note for that symbol
struct FakeCameraView: View {
    
    /// Allows this camera screen to close itself.
    ///
    /// This is used by both:
    /// - the close button in the camera interface
    /// - the "Keep Exploring" button after a photo is captured
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - Input Properties
    
    /// The `PhotoSymbol` being photographed.
    ///
    /// This contains the symbol name, location, historical note, and secret letter.
    let symbol: PhotoSymbol
    
    /// Indicates whether this symbol was already captured before opening the view.
    ///
    /// If this is `true`, the view skips the camera interface and immediately
    /// shows the Polaroid result.
    let alreadyCaptured: Bool
    
    /// A closure that runs when the player takes a photo.
    ///
    /// The parent view usually uses this to update `GameState` and record the
    /// symbol as photographed.
    let onCapture: (PhotoSymbol) -> Void
    
    
    // MARK: - State
    
    /// Tracks whether the player has taken a photo during this camera session.
    ///
    /// This is separate from `alreadyCaptured`.
    /// - `alreadyCaptured` means the symbol was captured before this view opened.
    /// - `hasTakenPhoto` means the player captured it during this current visit.
    @State private var hasTakenPhoto = false
    
    /// Controls the opacity of the white camera flash overlay.
    ///
    /// The value briefly jumps to `1.0`, then animates back to `0.0`.
    @State private var flashOpacity = 0.0
    
    
    // MARK: - Computed Properties
    
    /// Determines whether the Polaroid result should be displayed.
    ///
    /// The Polaroid appears if:
    /// - the symbol was already captured before opening the view, or
    /// - the player just took the photo during this session
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
    ///
    /// This gives the view a night-camera or investigation-tool feeling.
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
    
    
    // MARK: - Camera Interface
    
    /// The fake camera screen shown before the photo is taken.
    ///
    /// This includes:
    /// - a close button
    /// - a "PHOTO CLUE" label
    /// - a large viewfinder frame
    /// - symbol instructions
    /// - a shutter button
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
                Text("PHOTO CLUE")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
            
            Spacer()
            
            
            // MARK: Viewfinder
            
            VStack(spacing: 12) {
                
                // Large rounded rectangle that acts as the camera viewfinder.
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.85), lineWidth: 4)
                    .frame(height: 360)
                    .overlay {
                        VStack(spacing: 16) {
                            
                            // Viewfinder icon.
                            Image(systemName: "viewfinder")
                                .font(.system(size: 70))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            // Shows the name of the symbol being photographed.
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
            
            
            // MARK: Shutter Button
            
            /// Fake camera shutter button.
            ///
            /// Tapping this triggers:
            /// - the flash animation
            /// - the `onCapture` callback
            /// - the transition to the Polaroid result
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
    
    
    // MARK: - Polaroid Result
    
    /// The captured-photo result screen.
    ///
    /// This appears after the player takes a photo, or immediately if the
    /// symbol was already captured earlier.
    ///
    /// The result shows:
    /// - capture status
    /// - a Polaroid-style photo card
    /// - the hidden circled letter
    /// - the symbol's historical note
    /// - a button to return to exploration
    private var polaroidResult: some View {
        ScrollView {
            VStack(spacing: 22) {
                
                // The title changes depending on whether this is a newly
                // captured photo or a previously collected one.
                Text(alreadyCaptured && !hasTakenPhoto ? "Photo Already Collected" : "Photo Captured")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 36)
                
                
                // MARK: Polaroid Card
                
                VStack(spacing: 14) {
                    
                    // Dark placeholder image area inside the Polaroid.
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.88))
                        .frame(height: 310)
                        .overlay {
                            VStack(spacing: 18) {
                                
                                // Symbol/photo icon.
                                Image(systemName: "camera.macro")
                                    .font(.system(size: 72))
                                    .foregroundStyle(.yellow)
                                
                                // Name of the photographed symbol.
                                Text(symbol.symbolName)
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    
                    // Polaroid caption.
                    Text(symbol.symbolName)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    // Reveals the secret letter from this symbol.
                    HStack {
                        Text("Circled letter:")
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                        
                        Text(symbol.secretLetter)
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
                
                
                // MARK: Return Button
                
                // Closes the camera and returns the player to the location view.
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
    
    
    // MARK: - Photo Capture Logic
    
    /// Handles the fake photo-taking sequence.
    ///
    /// This function:
    /// - turns the white flash overlay fully visible
    /// - animates the flash back to transparent
    /// - waits briefly
    /// - records the captured symbol through `onCapture`
    /// - switches the view to the Polaroid result
    private func takePhoto() {
        
        // Instantly show the flash.
        flashOpacity = 1.0
        
        // Fade the flash away.
        withAnimation(.easeOut(duration: 0.45)) {
            flashOpacity = 0.0
        }
        
        // Delay slightly so the capture feels like it happens after the shutter.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onCapture(symbol)
            hasTakenPhoto = true
        }
    }
}


// MARK: - Preview

#Preview {
    FakeCameraView(
        symbol: .caveAndBasin,
        alreadyCaptured: false,
        onCapture: { _ in }
    )
}
