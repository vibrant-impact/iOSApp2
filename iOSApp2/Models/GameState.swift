//
//  GameState.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation
import Combine

final class GameState: ObservableObject {
    
    // MARK: - App State
    
    @Published var hasStartedGame = false
    @Published var currentLocation: Location = .museumExterior
    
    
    // MARK: - Museum Exterior
    
    @Published var hasOpenedMailbox = false
    @Published var hasReadMailboxNote = false
    @Published var hasCollectedShovel = false
    @Published var isMuseumDoorUnlocked = false
    @Published var hasSeenReturnFromLairMessage = false
    // @Published var hasPhotographedBigfootFootprint = false
    
    
    // MARK: - Museum Interior
    
    
    
    // MARK: - Bow Falls
    
    @Published var hasCollectedGaffHook = false
    @Published var hasOpenedFallsCanister = false
    @Published var hasCollectedWoodenMatches = false
    // @Published var hasPhotographedDouglasFirForest = false
    
    
    // MARK: - Cave and Basin
    
    @Published var hasOpenedBasinChest = false
    @Published var hasCollectedVintageBrassToken = false
    // @Published var hasPhotographedVent = false
    
    
    // MARK: - Banff Springs Hotel
    
    @Published var hasPhotographedGhostBride = false
    @Published var hasFoundCafeLead = false
    
    
    // MARK: - Downtown Banff
    
    @Published var hasEnteredSnowyOwlCafe = false
    @Published var hasTradedVintageBrassToken = false
    @Published var hasCollectedObservatoryStoryLead = false
    // @Published var hasPhotographedIceSculptures = false
    
    
    // MARK: - Upper Hot Springs
    
    @Published var hasCollectedObservatoryLockerKey = false
    // @Published var hasPhotographedMarilynMonroe = false
    // @Published var hasCollectedCafeLead = false
    
    // MARK: - Sulphur Mountain
    
    @Published var hasMeltedWeatherStationDoorIce = false
    // @Published var hasPhotographedBanffTown = false
    
    
    // MARK: - Observatory Interior
    
    @Published var hasReadObservatoryLogbook = false
    @Published var hasCollectedObservatoryJournalLead = false
    @Published var hasOpenedObservatoryLocker = false
    @Published var hasCollectedRustyCrowbar = false
    
    
    // MARK: - Lake Minnewanka
    
    @Published var hasOpenedMinnewankaCrate = false
    @Published var hasCollectedWoodcuttersAxe = false
    // @Published var hasPhotographedSunkenTown = false
    
    
    // MARK: - Tunnel Mountain
    
    @Published var hasBrokenCaveEntranceBoards = false
    @Published var hasTriggeredIcicleFall = false
    // @Published var hasPhotographedSnowyOwl = false
    
    
    // MARK: - Bigfoot's Lair
    
    @Published var hasWokenInBigfootLair = false
    @Published var hasInspectedLairExit = false
    @Published var hasMetBigfootFamily = false
    @Published var hasInspectedLostLemonMine = false
    @Published var hasTakenBigfootEvidencePhoto = false
    @Published var hasEscapedBigfootLair = false
    @Published var hasReturnedFromBigfootLair = false
    @Published var hasFoundGoldNuggetInPocket = false
    @Published var hasSpokenToCuratorAfterLair = false
    
    
    
    // MARK: - Inventory
    
    /// Items found at least once, even if later used.
    @Published var collectedInventoryItemIDs: Set<String> = []
    
    /// Items that have been consumed, traded, or spent.
    @Published var usedInventoryItemIDs: Set<String> = []
    
    /// Items currently visible in the player's bag.
    var inventory: [InventoryItem] {
        InventoryItem.all.filter { item in
            collectedInventoryItemIDs.contains(item.id)
            && !usedInventoryItemIDs.contains(item.id)
        }
    }
    
    /// Completion of all lair hotspot interaction triggers ejection from lair
    var hasCompletedRequiredLairInteractions: Bool {
        hasInspectedLairExit
        && hasMetBigfootFamily
        && hasInspectedLostLemonMine
        && hasTakenBigfootEvidencePhoto
    }
    
    // MARK: - Corkboard Leads
    
    let locationLeads: [LocationLead] = LocationLead.all
    
    
    // MARK: - Journal Photos
    
    /// Stores the IDs of photos taken that contribute to the journal and unlock letters.
    @Published var photoIDs: Set<String> = []
    
    let curatorAnswer = "SASQUATCH" // The final answer to the mystery.
    
    /// Computes the discovered letters from journal photos.
    var discoveredCuratorLetters: String {
        // Ensure the correct photos are mapped to letters through Photo.swift
        Photo.all
            .filter { photoIDs.contains($0.id) }
            .map { $0.secretLetter }
            .joined()
    }
    
    // Computed property for the total number of possible journal photos.
    var totalPhotoCount: Int {
        Photo.all.count
    }
    
    
    // MARK: - Inventory Helpers
    
    func collectInventoryItem(_ item: InventoryItem) {
        // If already collected and not used, do nothing.
        guard !collectedInventoryItemIDs.contains(item.id) || !usedInventoryItemIDs.contains(item.id) else { return }
        
        // If it was used, "re-collect" it by removing from used.
        if usedInventoryItemIDs.contains(item.id) {
            usedInventoryItemIDs.remove(item.id)
        }
        collectedInventoryItemIDs.insert(item.id)
        
        // Update specific @Published booleans for convenience.
        updateCollectedFlag(for: item)
    }
    
    func useInventoryItem(_ item: InventoryItem) {
        guard collectedInventoryItemIDs.contains(item.id) else { return }
        usedInventoryItemIDs.insert(item.id)
    }
    
    func hasInventoryItem(_ item: InventoryItem) -> Bool {
        collectedInventoryItemIDs.contains(item.id)
        && !usedInventoryItemIDs.contains(item.id)
    }
    
    func hasCollectedInventoryItem(_ item: InventoryItem) -> Bool {
        collectedInventoryItemIDs.contains(item.id)
    }
    
    func hasUsedInventoryItem(_ item: InventoryItem) -> Bool {
        usedInventoryItemIDs.contains(item.id)
    }
    
    func collectShovel() {
        collectInventoryItem(.smallShovel)
    }
    
    private func updateCollectedFlag(for item: InventoryItem) {
        switch item {
        case .smallShovel:
            hasCollectedShovel = true
        case .gaffHook:
            hasCollectedGaffHook = true
        case .woodenMatches:
            hasCollectedWoodenMatches = true
        case .cafeLead:
            hasFoundCafeLead = true
        case .vintageBrassToken:
            hasCollectedVintageBrassToken = true
        case .observatoryStoryLead:
            hasCollectedObservatoryStoryLead = true
        case .observatoryLockerKey:
            hasCollectedObservatoryLockerKey = true
        case .rustyCrowbar:
            hasCollectedRustyCrowbar = true
        case .woodcuttersAxe:
            hasCollectedWoodcuttersAxe = true
        case .observatoryJournalLead:
            hasCollectedObservatoryJournalLead = true
        case .lostLemonGoldNugget:
            hasReturnedFromBigfootLair = true
        }
    }
    
    
    // MARK: - Progression Requirements & Unlocks
    
    /// Checks if the player has the essential items for the second phase of the game.
    var hasCompletedSecondPhaseItems: Bool {
        hasCollectedInventoryItem(.gaffHook)
        && hasCollectedInventoryItem(.woodenMatches)
        && hasCollectedInventoryItem(.vintageBrassToken)
    }
    /// Checks if the player has enabled the observatory.
    var hasUnlockedObservatory: Bool {
        hasMeltedWeatherStationDoorIce
    }
    
    /// Checks if the player has enabled Lake Minnewanka.
    var hasUnlockedLakeMinnewanka: Bool {
        hasCollectedRustyCrowbar
    }
    
    /// Checks if the player has enabled Tunnel Mountain.
    var hasUnlockedTunnelMountain: Bool {
        hasCollectedWoodcuttersAxe
    }
    
    
    // MARK: - Corkboard Helpers
    
    /// Determines if a location lead is *available* to be selected from the corkboard.
    func isLocationLeadAvailable(_ lead: LocationLead) -> Bool {
        switch lead.location {
        case .bowFalls, .caveAndBasin, .banffSpringsHotel:
            return true // First phase locations are always available.
            
        case .hotSprings, .downtownBanff, .sulphurMountain:
            return hasCompletedSecondPhaseItems // Second phase available if first phase items are collected.
            
        case .observatory:
            return hasUnlockedObservatory // Available if door melted.
            
        case .lakeMinnewanka:
            return hasUnlockedLakeMinnewanka // Available if crowbar collected.
            
        case .tunnelMountain:
            return hasUnlockedTunnelMountain // Available if axe collected.
            
        case .museumExterior, .museumInterior, .bigfootLair:
            return true // These locations are not directly managed by corkboard progression.
        }
    }
    
    /// Checks if a location lead's primary objective has been met.
    func isLocationLeadCompleted(_ lead: LocationLead) -> Bool {
        switch lead.location {
        case .bowFalls:
            return hasCollectedGaffHook && hasCollectedWoodenMatches
        case .caveAndBasin:
            return hasCollectedVintageBrassToken
        case .banffSpringsHotel:
            return hasPhotographedGhostBride
        case .hotSprings:
            // Location is considered "completed" for corkboard purposes if the lead was found AND the researcher interaction happened.
            return hasFoundCafeLead && hasTradedVintageBrassToken
        case .downtownBanff:
            // Completed once the token is traded.
            return hasTradedVintageBrassToken
        case .sulphurMountain:
            return hasMeltedWeatherStationDoorIce
        case .observatory:
            return hasCollectedRustyCrowbar && hasCollectedObservatoryJournalLead
        case .lakeMinnewanka:
            return hasCollectedWoodcuttersAxe
        case .tunnelMountain:
            return hasTriggeredIcicleFall
        default:
            return false
        }
    }
    
    /// Navigates the player to a location, handling corkboard selection.
    func selectLocationLead(_ lead: LocationLead) {
        guard isLocationLeadAvailable(lead) else { return }
        currentLocation = lead.location
    }
    
    /// triggers ending sequence
    func finishBigfootLairSequence() {
        hasEscapedBigfootLair = true
        hasReturnedFromBigfootLair = true
        hasFoundGoldNuggetInPocket = true
        
        collectInventoryItem(.lostLemonGoldNugget)
        
        currentLocation = .museumExterior
    }
    
    // MARK: - Journal Photo Helpers
    
    func capturePhoto(_ photo: Photo) {
        guard !photoIDs.contains(photo.id) else { return }
        
        photoIDs.insert(photo.id)
        // Update specific @Published flags for photos that trigger unique game events.
        updatePhotoFlag(for: photo)
    }
    
    /// Checks if a specific Photo object has been captured.
    func hasPhoto(_ photo: Photo) -> Bool {
        photoIDs.contains(photo.id)
    }
    
    /// Checks if a photo with a specific ID has been captured.
    func hasPhoto(_ photoID: String) -> Bool {
        photoIDs.contains(photoID)
    }
    
    /// Returns all captured journal photos.
    var journalPhotos: [Photo] {
        Photo.all.filter { photoIDs.contains($0.id) }
    }
    
    /// The current count of journal photos taken.
    var photoCount: Int {
        photoIDs.count
    }
    
    /// Helper to update specific @Published flags for unique photo events.
    private func updatePhotoFlag(for photo: Photo) {
        switch photo.id {
        case Photo.museumExterior.id:
            // This photo might set a flag if needed for early game hints.
            break
        case Photo.bowFalls.id:
            break
        case Photo.caveAndBasin.id:
            break
        case Photo.banffSpringsHotel.id:
            hasPhotographedGhostBride = true
        case Photo.downtownBanff.id:
            break
        case Photo.hotSprings.id:
            break
        case Photo.sulphurMountain.id:
            // This photo might set a flag if needed for context.
            break
        case Photo.lakeMinnewanka.id:
            break
        case Photo.tunnelMountain.id:
            break
        default:
            break
        }
    }
    
    
    // MARK: - Rewards
    
    var photoRewardCode: String {
        switch photoCount {
        case 7...9:
            return "BANFF20"
        case 5...6:
            return "BANFF10"
        default:
            return "LOCKED"
        }
    }
    
    var photoRewardMessage: String {
        switch photoCount {
        case 7...9:
            return "You photographed \(photoCount) journal photos and unlocked a 20% discount code."
        case 5...6:
            return "You photographed \(photoCount) journal photos and unlocked a 10% discount code."
        default:
            return "You photographed \(photoCount) journal photos. Photograph at least 5 to unlock a discount code."
        }
    }
    
    
    // MARK: - Final Puzzle
    
    /// Checks if the player's final answer to the curator's question is correct.
    func isCuratorAnswerCorrect(_ answer: String) -> Bool {
        let cleanedAnswer = answer
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        return cleanedAnswer == curatorAnswer
    }
    
    
    // MARK: - Ending
    
    /// Determines the game ending based on photos and final answer.
    func ending(for answer: String) -> GameEnding {
        let solvedFinalAnswer = isCuratorAnswerCorrect(answer)
        
        if photoCount == totalPhotoCount && solvedFinalAnswer {
            return .legendaryLegacy
        }
        
        switch photoCount {
        case 7...9:
            return .newFunding
        case 5...6:
            return .interestReignited
        default:
            return .museumLost
        }
    }
}
    
    
