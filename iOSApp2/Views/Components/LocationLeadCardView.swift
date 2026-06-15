//
//  LocationLeadCardView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-13.
//

import SwiftUI

struct LocationLeadCardView: View {
    
    let lead: LocationLead
    let isUnlocked: Bool
    let isCompleted: Bool
    let action: () -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        Button {
            if isUnlocked {
                action()
            }
        } label: {
            HStack(spacing: 14) {
                iconBox
                
                VStack(alignment: .leading, spacing: 5) {
                    titleRow
                    
                    Text(lead.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(isUnlocked ? 0.75 : 0.45))
                        .multilineTextAlignment(.leading)
                    
                    Text(lead.publicMystery)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(isUnlocked ? 0.62 : 0.35))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(borderColor, lineWidth: 1)
            }
            .opacity(isUnlocked ? 1.0 : 0.55)
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
    }
    
    
    // MARK: - Subviews
    
    private var iconBox: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(iconBackground)
                .frame(width: 52, height: 52)
            
            Image(systemName: cardIcon)
                .font(.title2)
                .foregroundStyle(iconColor)
        }
    }
    
    private var titleRow: some View {
        HStack {
            Text(lead.title)
                .font(.headline)
                .foregroundStyle(.white)
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else if !isUnlocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
    }
    
    
    // MARK: - Styling
    
    private var cardIcon: String {
        if isCompleted {
            return "checkmark"
        }
        
        if !isUnlocked {
            return "lock.fill"
        }
        
        return lead.systemImage
    }
    
    private var iconBackground: Color {
        if isCompleted {
            return .green.opacity(0.25)
        }
        
        if !isUnlocked {
            return .gray.opacity(0.25)
        }
        
        return .orange.opacity(0.25)
    }
    
    private var iconColor: Color {
        if isCompleted {
            return .green
        }
        
        if !isUnlocked {
            return .white.opacity(0.45)
        }
        
        return .orange
    }
    
    private var cardBackground: Color {
        if isCompleted {
            return .green.opacity(0.13)
        }
        
        if !isUnlocked {
            return .black.opacity(0.25)
        }
        
        return .white.opacity(0.08)
    }
    
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
        Color.black.ignoresSafeArea()
        
        LocationLeadCardView(
            lead: LocationLead.all[0],
            isUnlocked: true,
            isCompleted: false,
            action: {}
        )
        .padding()
    }
}

