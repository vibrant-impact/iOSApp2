//
//  InventoryItem.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

/// Represents an item the player can collect and use during the investigation.
///
/// Inventory items are different from evidence items:
/// - Inventory items are tools or usable objects.
/// - Evidence items are clues that prove story progress.
///
/// Example inventory items:
/// - shovel
/// - towel
/// - net
///
/// These items are stored in `GameState` and shown in `InventoryView`.
struct InventoryItem: Identifiable, Equatable {
    
    /// A unique string used to identify this inventory item.
    ///
    /// The id is used by `GameState` to check whether the player already
    /// has this item.
    ///
    /// Example:
    /// `"small_shovel"`
    let id: String
    
    /// The display name shown to the player.
    ///
    /// Example:
    /// `"Small Shovel"`
    let name: String
    
    /// A short explanation of what the item is and how it might be useful.
    ///
    /// This text appears in the inventory list and helps hint at where the item
    /// can be used.
    let description: String
}


// MARK: - Inventory Item Library

extension InventoryItem {
    
    /// A small shovel found near the museum exterior.
    ///
    /// The shovel is useful for uncovering buried objects in snow or dirt.
    static let smallShovel = InventoryItem(
        id: "small_shovel",
        name: "Small Shovel",
        description: "A little metal shovel half-buried in the snow. Useful for digging through packed snow or uncovering small clues."
    )
    
    /// An old towel stained by mineral water.
    ///
    /// The towel can be used to collect fine residue, such as dust or minerals,
    /// without needing a special container.
    static let oldTowel = InventoryItem(
        id: "old_towel",
        name: "Old Towel",
        description: "A stiff old towel stained by mineral water. It might be useful for collecting fine dust or residue."
    )
    
    /// A long-handled net used to reach objects in water.
    ///
    /// This item helps the player retrieve submerged clues without touching
    /// unsafe or protected water directly.
    static let longHandledNet = InventoryItem(
        id: "long_handled_net",
        name: "Long-Handled Net",
        description: "A long-handled net, useful for retrieving objects from water without reaching in by hand."
    )
}
