//
//  InventoryItem.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

struct InventoryItem: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
}

extension InventoryItem {
    static let smallShovel = InventoryItem(
        id: "small_shovel",
        name: "Small Shovel",
        description: "A little metal shovel half-buried in the snow. Useful for digging through packed snow or uncovering small clues."
    )
    
    static let oldTowel = InventoryItem(
        id: "old_towel",
        name: "Old Towel",
        description: "A stiff old towel stained by mineral water. It might be useful for collecting fine dust or residue."
    )
    
    static let longHandledNet = InventoryItem(
        id: "long_handled_net",
        name: "Long-Handled Net",
        description: "A long-handled net, useful for retrieving objects from water without reaching in by hand."
    )
}
