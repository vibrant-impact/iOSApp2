//
//  InventoryView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct InventoryView: View {
    
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            HStack {
            
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding()
                
    
                Text("Bag")
                    .font(.title.bold())
                    .foregroundStyle(.white)
           
                Spacer()
            }
            .padding()
            
            List {
                if gameState.inventory.isEmpty {
                    emptyInventoryView
                } else {
                    inventoryRows
                }
            }
        }
    }
    
    
    // MARK: - Empty State
    
    private var emptyInventoryView: some View {
        VStack(spacing: 12) {
            Image(systemName: "backpack")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            
            Text("Your Bag is Empty")
                .font(.headline)
            
            Text("Collected tools and useful items will appear here until they are used.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    
    // MARK: - Rows
    
    private var inventoryRows: some View {
        ForEach(gameState.inventory) { item in
            HStack(alignment: .top, spacing: 12) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46)
                    .padding(5)
                    .background(.orange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10)
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.displayName)
                        .font(.headline)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 6)
        }
    }
}


// MARK: - Preview

#Preview {
    InventoryView()
        .environmentObject(GameState())
}
