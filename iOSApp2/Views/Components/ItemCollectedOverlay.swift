//
//  ItemCollectedOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import SwiftUI

struct ItemCollectedOverlay: View {
    
    let item: InventoryItem
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Item Collected")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .padding()
                    .background(.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                
                Text(item.displayName)
                    .font(.headline)
                    .foregroundStyle(.yellow)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                
                Button {
                    onDismiss()
                } label: {
                    Text("Add to Bag")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color.black.opacity(0.88))
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .padding(.horizontal, 32)
        }
    }
}
