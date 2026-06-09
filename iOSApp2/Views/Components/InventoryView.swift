//
//  InventoryView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// Displays the player's inventory bag.
///
/// This view shows any tools, objects, or important items the player has
/// collected during the game.
///
/// If the inventory is empty, the view shows an empty-state message.
/// If the player has collected items, each item appears in a list with its
/// name and description.
struct InventoryView: View {
    
    /// The shared game state for the whole app.
    ///
    /// This provides access to the player's current inventory.
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                
                // If the player has not collected any items yet,
                // show a helpful empty-state message instead of a blank list.
                if gameState.inventory.isEmpty {
                    emptyInventoryView
                } else {
                    inventoryRows
                }
            }
            .navigationTitle("Bag")
        }
    }
    
    
    // MARK: - Empty Inventory View
    
    /// The message shown when the player's bag is empty.
    ///
    /// This helps the player understand that tools and collected items will
    /// appear here later.
    private var emptyInventoryView: some View {
        VStack(spacing: 12) {
            
            // Backpack icon representing the player's bag.
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
    }
    
    
    // MARK: - Inventory Rows
    
    /// Displays one row for each item in the player's inventory.
    ///
    /// Each item row includes:
    /// - the item name
    /// - the item description
    private var inventoryRows: some View {
        ForEach(gameState.inventory) { item in
            VStack(alignment: .leading, spacing: 6) {
                
                // Main item title.
                Text(item.name)
                    .font(.headline)
                
                // Short explanation of what the item is or why it matters.
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
