//
//  LeadCardView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A card-style button that represents one investigation lead on the corkboard.
///
/// `LeadCardView` is used inside `CorkboardView`.
/// Each card shows:
/// - the lead icon
/// - the lead title
/// - the lead subtitle
/// - a short public mystery description
/// - a lock icon if the lead is unavailable
/// - a completion checkmark if the lead is finished
///
/// The card only runs its action when the lead is unlocked.
struct LeadCardView: View {
    
    /// The story lead shown by this card.
    let lead: StoryLead
    
    /// Whether the player is allowed to open this lead.
    ///
    /// Locked leads are dimmed, disabled, and show a lock icon.
    let isUnlocked: Bool
    
    /// Whether the player has completed this lead.
    ///
    /// Completed leads show a green checkmark and green styling.
    let isCompleted: Bool
    
    /// The action that runs when the player taps this card.
    ///
    /// This is only used when `isUnlocked` is `true`.
    let action: () -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        Button {
            
            // Only allow the card to trigger its action when it is unlocked.
            //
            // The `.disabled(!isUnlocked)` modifier below also prevents taps,
            // but this extra check keeps the logic safe.
            if isUnlocked {
                action()
            }
        } label: {
            HStack(spacing: 14) {
                
                // MARK: Icon Box
                
                ZStack {
                    
                    // Rounded square behind the icon.
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)
                        .frame(width: 52, height: 52)
                    
                    // Icon changes depending on card state:
                    // - checkmark for completed
                    // - lock for locked
                    // - lead's own icon for available
                    Image(systemName: cardIcon)
                        .font(.title2)
                        .foregroundStyle(iconColor)
                }
                
                
                // MARK: Text Content
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    // Title row with optional status icon.
                    HStack {
                        Text(lead.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        // Show completion or locked state on the right side.
                        if isCompleted {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        } else if !isUnlocked {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.white.opacity(0.55))
                        }
                    }
                    
                    // Lead subtitle.
                    Text(lead.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(isUnlocked ? 0.75 : 0.45))
                        .multilineTextAlignment(.leading)
                    
                    // Short clue/mystery description shown before opening the lead.
                    Text(lead.publicMystery)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(isUnlocked ? 0.62 : 0.35))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .padding()
            
            // Card background changes based on unlocked/completed state.
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                
                // Thin border around the card.
                RoundedRectangle(cornerRadius: 18)
                    .stroke(borderColor, lineWidth: 1)
            }
            
            // Locked cards are faded.
            .opacity(isUnlocked ? 1.0 : 0.55)
        }
        
        // Removes default button styling so the card keeps its custom design.
        .buttonStyle(.plain)
        
        // Prevents locked cards from being tapped.
        .disabled(!isUnlocked)
    }
    
    
    // MARK: - Card Icon
    
    /// Chooses the icon displayed in the left icon box.
    ///
    /// Priority:
    /// 1. completed card gets a checkmark
    /// 2. locked card gets a lock
    /// 3. unlocked incomplete card uses the lead's own SF Symbol
    private var cardIcon: String {
        if isCompleted {
            return "checkmark"
        }
        
        if !isUnlocked {
            return "lock.fill"
        }
        
        return lead.systemImage
    }
    
    
    // MARK: - Icon Background
    
    /// Chooses the background color behind the card icon.
    ///
    /// Completed cards use green, locked cards use gray, and active cards use
    /// orange to match the corkboard clue style.
    private var iconBackground: Color {
        if isCompleted {
            return .green.opacity(0.25)
        }
        
        if !isUnlocked {
            return .gray.opacity(0.25)
        }
        
        return .orange.opacity(0.25)
    }
    
    
    // MARK: - Icon Color
    
    /// Chooses the foreground color for the card icon.
    private var iconColor: Color {
        if isCompleted {
            return .green
        }
        
        if !isUnlocked {
            return .white.opacity(0.45)
        }
        
        return .orange
    }
    
    
    // MARK: - Card Background
    
    /// Chooses the main card background color.
    ///
    /// - completed cards have a subtle green tint
    /// - locked cards are darker
    /// - unlocked active cards have a light translucent background
    private var cardBackground: Color {
        if isCompleted {
            return .green.opacity(0.13)
        }
        
        if !isUnlocked {
            return .black.opacity(0.25)
        }
        
        return .white.opacity(0.08)
    }
    
    
    // MARK: - Border Color
    
    /// Chooses the card border color.
    ///
    /// The border reinforces the card state:
    /// - green for completed
    /// - faint white for locked
    /// - orange for available leads
    private var borderColor: Color {
        if isCompleted {
            return .green.opacity(0.45)
        }
        
        if !isUnlocked {
            return .white.opacity(0.08)
        }
        
        return .orange.opacity(0.35)
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        
        // Dark background matches the corkboard/museum UI style.
        Color.black.ignoresSafeArea()
        
        LeadCardView(
            lead: StoryLead.all[0],
            isUnlocked: true,
            isCompleted: false,
            action: {}
        )
        .padding()
    }
}
