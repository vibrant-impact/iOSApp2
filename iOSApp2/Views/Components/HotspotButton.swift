//
//  HotspotButton.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A pulsing interactive button used to mark tappable hotspots in a scene.
///
/// `HotspotButton` is usually placed on top of a scene image to show the player
/// that something can be inspected, opened, collected, or investigated.
///
/// The button includes:
/// - a pulsing outer ring
/// - a colored circular icon
/// - a small text label underneath
struct HotspotButton: View {
    
    /// The label shown under the hotspot icon.
    ///
    /// Example:
    /// `"Mailbox"`
    let title: String
    
    /// The SF Symbol displayed inside the hotspot circle.
    ///
    /// Example:
    /// `"envelope.fill"`
    let systemImage: String
    
    /// The main color used for the hotspot circle and pulse ring.
    ///
    /// Different colors can help show different hotspot types, such as:
    /// - red for important clues
    /// - yellow for evidence
    /// - blue for navigation
    let color: Color
    
    /// The action that runs when the player taps the hotspot.
    ///
    /// Parent views use this to open clues, move locations, start puzzles,
    /// or trigger game progress.
    let action: () -> Void
    
    
    // MARK: - State
    
    /// Controls the pulse animation.
    ///
    /// When `pulse` changes to `true`, the outer ring grows and fades.
    /// Because the animation repeats forever, this creates a constant pulsing
    /// effect that draws the player's attention.
    @State private var pulse = false
    
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                
                // MARK: Icon and Pulse Ring
                
                ZStack {
                    
                    // Animated outer ring.
                    //
                    // The ring grows from 46 to 62 points and fades as it grows,
                    // creating a pulse effect around the hotspot.
                    Circle()
                        .stroke(color.opacity(0.65), lineWidth: 3)
                        .frame(width: pulse ? 62 : 46, height: pulse ? 62 : 46)
                        .opacity(pulse ? 0.15 : 0.8)
                    
                    // Solid inner circle.
                    Circle()
                        .fill(color.opacity(0.95))
                        .frame(width: 42, height: 42)
                    
                    // SF Symbol icon inside the hotspot.
                    Image(systemName: systemImage)
                        .font(.headline)
                        .foregroundStyle(.black.opacity(0.8))
                }
                
                
                // MARK: Label
                
                // Small capsule label under the icon.
                Text(title)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.45))
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
            }
        }
        
        // Keeps the button from using the default SwiftUI button styling.
        // This preserves the custom hotspot appearance.
        .buttonStyle(.plain)
        
        // Starts the pulsing animation when the button appears on screen.
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


// MARK: - Preview

#Preview {
    ZStack {
        
        // Dark background makes the hotspot pulse easy to see.
        Color.black.ignoresSafeArea()
        
        HotspotButton(
            title: "Mailbox",
            systemImage: "envelope.fill",
            color: .red,
            action: {}
        )
    }
}
