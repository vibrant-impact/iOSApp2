//
//  TopHUDView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct TopHUDView: View {
    let locationTitle: String
    let locationSubtitle: String
    let onBagTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(locationTitle)
                        .font(.headline.bold())
                    
                    Text(locationSubtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                }
                
                Spacer()
                
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
            .background(.black.opacity(0.25))
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        
        TopHUDView(
            locationTitle: "Heart of the Wild",
            locationSubtitle: "Secrets of Banff",
            onBagTapped: {}
        )
    }
}
