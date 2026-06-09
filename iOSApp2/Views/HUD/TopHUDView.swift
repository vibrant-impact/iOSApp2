//
//  TopHUDView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A top heads-up display used on exploration screens.
///
/// `TopHUDView` sits at the top of a scene and shows:
/// - the current location title
/// - a short location subtitle
/// - a bag button for opening the inventory
///
/// This view does not manage inventory itself.
/// Instead, it calls `onBagTapped` and lets the parent view decide what to do.
struct TopHUDView: View {
    
    /// The main title shown in the HUD.
    ///
    /// This is usually the current location name.
    ///
    /// Example:
    /// `"Heart of the Wild"`
    let locationTitle: String
    
    /// The smaller subtitle shown under the title.
    ///
    /// This can describe the location, chapter, or investigation area.
    ///
    /// Example:
    /// `"Secrets of Banff"`
    let locationSubtitle: String
    
    /// Runs when the player taps the bag button.
    ///
    /// Parent views typically use this to show `InventoryView` in a sheet.
    let onBagTapped: () -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            
            // MARK: Top Bar
            
            HStack {
                
                // MARK: Location Text
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    // Main location title.
                    Text(locationTitle)
                        .font(.headline.bold())
                    
                    // Smaller supporting subtitle.
                    Text(locationSubtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                }
                
                Spacer()
                
                
                // MARK: Bag Button
                
                // Opens the inventory or bag screen through the parent view.
                Button {
                    onBagTapped()
                } label: {
                    Label("Bag", systemImage: "backpack.fill")
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.35))
                        .clipShape(Capsule())
                }
                .foregroundStyle(.white)
            }
            .padding()
            
            // A translucent dark background helps the HUD remain readable
            // on top of bright or detailed scene artwork.
            .background(.black.opacity(0.25))
            
            // Pushes the HUD to the top of the screen.
            Spacer()
        }
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        
        // Simple colored background for previewing the HUD contrast.
        Color.blue.ignoresSafeArea()
        
        TopHUDView(
            locationTitle: "Heart of the Wild",
            locationSubtitle: "Secrets of Banff",
            onBagTapped: {}
        )
    }
}
