//
//  TopHUDView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// A top heads-up display used on exploration screens.
struct TopHUDView: View {
    
    let locationTitle: String
    let locationSubtitle: String
    
    var showsBagButton: Bool = true
    var showsJournalButton: Bool = true
    
    let onBagTapped: () -> Void
    let onJournalTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(locationTitle)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text(locationSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.78))
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    if showsJournalButton {
                        Button {
                            onJournalTapped()
                        } label: {
                            Label(
                                "Journal",
                                systemImage: "book.closed.fill"
                            )
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                    }
                    
                    if showsBagButton {
                        Button {
                            onBagTapped()
                        } label: {
                            Label(
                                "Bag",
                                systemImage: "backpack.fill"
                            )
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 14)
            .padding(.bottom, 10)
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.72),
                        Color.black.opacity(0.32)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            Spacer()
        }
    }
}

