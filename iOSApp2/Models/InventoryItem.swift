//
//  InventoryItem.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation

enum InventoryItem: String, Identifiable, CaseIterable {
    case smallShovel
    case gaffHook
    case woodenMatches
    case cafeLead
    case vintageBrassToken
    case observatoryStoryLead
    case observatoryLockerKey
    case rustyCrowbar
    case woodcuttersAxe
    case observatoryJournalLead
    case lostLemonGoldNugget
    
    var id: String { rawValue }
    
    static var all: [InventoryItem] {
        Array(allCases)
    }
    
    var displayName: String {
        switch self {
        case .smallShovel:
            return "Small Shovel"
        case .gaffHook:
            return "Gaff Hook"
        case .woodenMatches:
            return "Wooden Matches"
        case .cafeLead:
            return "Snowy Owl Cafe Lead"
        case .vintageBrassToken:
            return "Vintage Brass Token"
        case .observatoryStoryLead:
            return "Observatory Story Lead"
        case .observatoryLockerKey:
            return "Observatory Locker Key"
        case .rustyCrowbar:
            return "Rusty Crowbar"
        case .woodcuttersAxe:
            return "Woodcutter's Axe"
        case .observatoryJournalLead:
            return "Observatory Journal Entry"
        case .lostLemonGoldNugget:
            return "Lost Lemon Gold Nugget"
        }
    }
    
    var imageName: String {
        switch self {
        case .smallShovel:
            return "item_small_shovel"
        case .gaffHook:
            return "item_gaff_hook"
        case .woodenMatches:
            return "item_wooden_matches"
        case .cafeLead:
            return "item_cafe_lead"
        case .vintageBrassToken:
            return "item_vintage_brass_token"
        case .observatoryStoryLead:
            return "item_observatory_story_lead"
        case .observatoryLockerKey:
            return "item_observatory_locker_key"
        case .rustyCrowbar:
            return "item_rusty_crowbar"
        case .woodcuttersAxe:
            return "item_woodcutters_axe"
        case .observatoryJournalLead:
            return "item_journal_page"
        case .lostLemonGoldNugget:
            return "item_lost_lemon_gold_nugget"
        }
    }
    
    var description: String {
        switch self {
        case .smallShovel:
            return "A little metal shovel, perfect for digging through packed snow."
        case .gaffHook:
            return "A sturdy hooked pole that can snag objects just out of reach."
        case .woodenMatches:
            return "Dry wooden matches sealed in a canister. Useful for melting thick ice."
        case .cafeLead:
            return "Scribblings on a napkin point toward the Snowy Owl Cafe in downtown Banff."
        case .vintageBrassToken:
            return "An old brass token stamped with a worn Banff emblem."
        case .observatoryStoryLead:
            return "A local research lead pointing toward Sulphur Mountain's old observatory."
        case .observatoryLockerKey:
            return "A green key for an old metal locker inside the observatory."
        case .rustyCrowbar:
            return "A heavy crowbar, rusted but strong enough to pry open frozen crates."
        case .woodcuttersAxe:
            return "A sharp woodcutter's axe, heavy enough to break through old boards."
        case .observatoryJournalLead:
            return "A journal entry pointing toward Tunnel Mountain. Is it referencing Bigfoot?"
        case .lostLemonGoldNugget:
            return "A massive gold nugget from the legendary Lost Lemon Mine."
        }
    }
    
    var systemImage: String {
        switch self {
        case .smallShovel:
            return "spade.fill"
        case .gaffHook:
            return "hook"
        case .woodenMatches:
            return "flame.fill"
        case .cafeLead:
            return "note.text"
        case .vintageBrassToken:
            return "circle.hexagongrid.fill"
        case .observatoryStoryLead:
            return "binoculars.fill"
        case .observatoryLockerKey:
            return "key.fill"
        case .rustyCrowbar:
            return "hammer.fill"
        case .woodcuttersAxe:
            return "axe"
        case .observatoryJournalLead:
            return "square.and.pencil.circle.fill"
        case .lostLemonGoldNugget:
            return "sparkles"
        }
    }
}
