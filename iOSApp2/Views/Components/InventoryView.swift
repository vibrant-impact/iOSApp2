//
//  InventoryView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct InventoryView: View {
    @EnvironmentObject private var gameState: GameState
    
    var body: some View {
        NavigationStack {
            List {
                if gameState.inventory.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "backpack")
                            .font(.system(size: 42))
                            .foregroundStyle(.secondary)
                        
                        Text("Your Bag is Empty")
                            .font(.headline)
                        
                        Text("Collected tools and evidence will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    ForEach(gameState.inventory) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Bag")
        }
    }
}

#Preview {
    InventoryView()
        .environmentObject(GameState())
}
