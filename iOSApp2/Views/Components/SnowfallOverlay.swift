//
//  SnowfallOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A decorative overlay that draws random snowflakes across the screen.
///
/// `SnowfallOverlay` is meant to sit on top of a scene as a visual effect.
/// It does not respond to taps, so the player can still interact with buttons
/// and hotspots underneath it.
///
/// This version creates a static snowfall pattern using small white circles.
struct SnowfallOverlay: View {
    
    /// The number of snowflakes to draw.
    ///
    /// `Array(0..<45)` creates 45 placeholder values.
    /// Each value is used by `ForEach` to create one snowflake.
    private let flakes = Array(0..<45)
    
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            
            // `GeometryReader` gives access to the available screen size.
            // That size is used to randomly position each snowflake.
            ZStack {
                
                // Creates one circle for each snowflake.
                ForEach(flakes, id: \.self) { _ in
                    
                    // A small white circle represents a snowflake.
                    Circle()
                    
                        // Random opacity makes some flakes brighter than others,
                        // giving the snowfall more depth.
                        .fill(.white.opacity(Double.random(in: 0.25...0.75)))
                    
                        // Random size makes the snowflakes feel less uniform.
                        .frame(
                            width: CGFloat.random(in: 2...5),
                            height: CGFloat.random(in: 2...5)
                        )
                    
                        // Random position places each flake somewhere within
                        // the available view area.
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
            }
        }
        
        // Allows taps to pass through the snow overlay.
        //
        // Without this, the overlay could block buttons, image hotspots,
        // or other interactive scene elements underneath it.
        .allowsHitTesting(false)
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        
        // Blue background makes the white snowflakes easy to see in preview.
        Color.blue.ignoresSafeArea()
        
        SnowfallOverlay()
    }
}
