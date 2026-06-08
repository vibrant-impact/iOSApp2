//
//  GameState.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation
import Combine

/// GameState is the main shared "brain" of the game.
/// It tracks the player's current location, inventory, story progress,
/// collected evidence, optional photo scavenger hunt progress, and endings.
final class GameState: ObservableObject {
    
    // MARK: - App Start State

    /// Tracks whether the player has left the welcome screen and started the game.
    @Published var hasStartedGame: Bool = false
    
    // MARK: - Current Location
    
    /// The location currently being displayed by ContentView.
    @Published var currentLocation: Location = .museumExterior
    
    
    // MARK: - Museum Exterior Progress
    
    /// Tracks whether the player has read the museum curator's note in the mailbox.
    @Published var hasReadMailboxNote: Bool = false
    
    /// Tracks whether the player has picked up the shovel outside the museum.
    @Published var hasCollectedShovel: Bool = false
    
    /// Tracks whether the museum door lock has been solved.
    @Published var isMuseumDoorUnlocked: Bool = false
    
    
    // MARK: - Inventory
    
    /// Items the player has collected and can use later.
    @Published var inventory: [InventoryItem] = []
    
    
    // MARK: - Story Leads and Evidence
    
    /// All story leads available in the game.
    @Published var storyLeads: [StoryLead] = StoryLead.all
    
    /// The IDs of story leads the player has completed.
    @Published var completedLeadIDs: Set<String> = []
    
    /// Story evidence collected during investigations.
    @Published var collectedEvidence: [EvidenceItem] = []
    
    
    // MARK: - Optional Photo Scavenger Hunt
    
    /// The IDs of optional historical symbols the player has photographed.
    /// These are separate from story evidence.
    @Published var photographedSymbolIDs: Set<String> = []
    
    /// The hidden curator name needed for the grand prize ending.
    let curatorNameAnswer: String = "JACQUELINE"
    
    
    // MARK: - Inventory Helpers
    
    /// Adds an item to the player's inventory, but only if it is not already there.
    func addInventoryItem(_ item: InventoryItem) {
        guard !hasInventoryItem(item.id) else { return }
        inventory.append(item)
    }
    
    /// Checks whether the player already has an inventory item.
    func hasInventoryItem(_ id: String) -> Bool {
        inventory.contains { $0.id == id }
    }
    
    /// Collects the shovel from the museum exterior.
    /// This also adds the shovel to the inventory.
    func collectShovel() {
        guard !hasCollectedShovel else { return }
        
        hasCollectedShovel = true
        addInventoryItem(.smallShovel)
    }
    
    
    // MARK: - Evidence Helpers
    
    /// Adds story evidence, but only if it has not already been collected.
    func collectEvidence(_ evidence: EvidenceItem) {
        guard !hasEvidence(evidence.id) else { return }
        collectedEvidence.append(evidence)
    }
    
    /// Checks whether a specific piece of evidence has already been collected.
    func hasEvidence(_ id: String) -> Bool {
        collectedEvidence.contains { $0.id == id }
    }
    
    /// Tracks whether the player has retrieved the dark object from the Cave and Basin pool.
    /// This is required to unlock the second phase of locations.
    var hasRecoveredCavePoolObject: Bool {
        hasEvidence(EvidenceItem.sealedOilclothFragment.id)
    }
    
    
    // MARK: - Lead Groups
    
    /// First phase leads.
    var firstPhaseLeads: [StoryLead] {
        storyLeads.filter { $0.phase == .first }
    }
    
    /// Second phase leads.
    var secondPhaseLeads: [StoryLead] {
        storyLeads.filter { $0.phase == .second }
    }
    
    /// Final phase leads.
    var finalPhaseLeads: [StoryLead] {
        storyLeads.filter { $0.phase == .final }
    }
    
    /// Returns true when all first phase leads are completed.
    var hasCompletedFirstPhase: Bool {
        firstPhaseLeads.allSatisfy { completedLeadIDs.contains($0.id) }
    }
    
    /// Returns true when all second phase leads are completed.
    var hasCompletedSecondPhase: Bool {
        secondPhaseLeads.allSatisfy { completedLeadIDs.contains($0.id) }
    }
    
    
    // MARK: - Lead Unlocking
    
    /// Determines whether a lead can currently be selected.
    ///
    /// First phase leads are always available.
    /// Second phase leads require:
    /// - all first phase leads completed
    /// - the Cave and Basin pool object recovered
    ///
    /// Final phase leads require:
    /// - all first phase leads completed
    /// - all second phase leads completed
    /// - the Cave and Basin pool object recovered
    func isLeadUnlocked(_ lead: StoryLead) -> Bool {
        switch lead.phase {
        case .first:
            return true
            
        case .second:
            return hasCompletedFirstPhase && hasRecoveredCavePoolObject
            
        case .final:
            return hasCompletedFirstPhase && hasCompletedSecondPhase && hasRecoveredCavePoolObject
        }
    }
    
    /// Checks whether a lead has already been completed.
    func isLeadCompleted(_ lead: StoryLead) -> Bool {
        completedLeadIDs.contains(lead.id)
    }
    
    /// Moves the player to the selected lead's location if it is unlocked.
    func selectLead(_ lead: StoryLead) {
        guard isLeadUnlocked(lead) else { return }
        currentLocation = lead.location
    }
    
    /// Marks a lead as complete.
    ///
    /// The `addPlaceholderEvidence` option exists so placeholder leads can still work,
    /// but real custom locations can complete without adding generic placeholder evidence.
    func completeLead(_ lead: StoryLead, addPlaceholderEvidence: Bool = true) {
        completedLeadIDs.insert(lead.id)
        
        if addPlaceholderEvidence {
            let evidence = EvidenceItem.placeholderEvidence(for: lead)
            collectEvidence(evidence)
        }
    }
    
    /// Checks whether the required evidence for a lead has been collected.
    /// If yes, the lead is marked complete.
    func completeLeadIfNeeded(_ lead: StoryLead) {
        guard !isLeadCompleted(lead) else { return }
        
        let requiredEvidenceIDs = requiredEvidenceIDs(for: lead)
        
        guard !requiredEvidenceIDs.isEmpty else { return }
        
        let hasAllRequiredEvidence = requiredEvidenceIDs.allSatisfy { evidenceID in
            hasEvidence(evidenceID)
        }
        
        if hasAllRequiredEvidence {
            completeLead(lead, addPlaceholderEvidence: false)
        }
    }
    
    /// Lists the required story evidence for each lead.
    ///
    /// These are required for story progression.
    /// They are separate from optional photo scavenger hunt symbols.
    func requiredEvidenceIDs(for lead: StoryLead) -> [String] {
        switch lead.id {
        case "cave_and_basin":
            return [
                EvidenceItem.caveSignPhoto.id,
                EvidenceItem.goldDustedCloth.id
            ]
            
        case "bow_falls":
            return [
                EvidenceItem.parksNetTagPhoto.id,
                EvidenceItem.oldSurveyMarker.id
            ]
            
        case "banff_springs_hotel":
            return [
                EvidenceItem.guestLedgerPage.id,
                EvidenceItem.servicePathFootprint.id
            ]
            
        case "hot_springs":
            return [
                EvidenceItem.mineralSpringToken.id
            ]
            
        case "sulphur_mountain_gondola":
            return [
                EvidenceItem.ridgeRouteMarker.id
            ]
            
        case "tunnel_mountain":
            return [
                EvidenceItem.tunnelMountainTrack.id
            ]
            
        default:
            return []
        }
    }
    
    /// Finds the story lead connected to a specific location.
    func lead(for location: Location) -> StoryLead? {
        storyLeads.first { $0.location == location }
    }
    
    
    // MARK: - Optional Photo Scavenger Hunt Helpers
    
    /// Records that the player photographed an optional historical symbol.
    ///
    /// These photos are used for:
    /// - discount rewards
    /// - ending quality
    /// - hidden curator name letters
    func photographSymbol(_ symbol: PhotoSymbol) {
        photographedSymbolIDs.insert(symbol.id)
    }
    
    /// Checks whether a specific optional photo symbol has already been photographed.
    func hasPhotographedSymbol(_ symbolID: String) -> Bool {
        photographedSymbolIDs.contains(symbolID)
    }
    
    /// Number of optional historical symbols the player has photographed.
    var photographedSymbolCount: Int {
        photographedSymbolIDs.count
    }
    
    /// Total number of optional historical photo symbols in the game.
    var totalPhotoSymbolCount: Int {
        PhotoSymbol.all.count
    }
    
    /// Reveals the secret letters from photographed symbols in the intended order.
    ///
    /// If all 10 symbols are collected, this should spell:
    /// JACQUELINE
    var discoveredCuratorLetters: String {
        PhotoSymbol.all
            .filter { photographedSymbolIDs.contains($0.id) }
            .map { $0.secretLetter }
            .joined()
    }
    
    
    // MARK: - Discount Rewards
    
    /// Discount code based on the number of optional symbols photographed.
    ///
    /// Reward tiers:
    /// - 0 to 5 symbols: no discount
    /// - 6 to 8 symbols: 10% discount
    /// - 9 to 10 symbols: 20% discount
    var photoRewardCode: String {
        switch photographedSymbolCount {
        case 9...10:
            return "BANFF20"
        case 6...8:
            return "BANFF10"
        default:
            return "LOCKED"
        }
    }
    
    /// User-facing reward message for the submission screen.
    var photoRewardMessage: String {
        switch photographedSymbolCount {
        case 9...10:
            return "You photographed \(photographedSymbolCount) historical symbols and unlocked a 20% discount code."
            
        case 6...8:
            return "You photographed \(photographedSymbolCount) historical symbols and unlocked a 10% discount code."
            
        default:
            return "You photographed \(photographedSymbolCount) historical symbols. Photograph at least 6 to unlock a discount code."
        }
    }
    
    
    // MARK: - Curator Name Puzzle
    
    /// Checks whether the player entered the correct curator name.
    func isCuratorAnswerCorrect(_ answer: String) -> Bool {
        let cleanedAnswer = answer
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        return cleanedAnswer == curatorNameAnswer
    }
    
    
    // MARK: - Ending
    
    /// Determines which ending the player receives.
    ///
    /// Ending logic:
    /// - 0 to 5 photos: museum lost
    /// - 6 to 8 photos: partial exhibit
    /// - 9 or 10 photos: museum saved
    /// - all 10 photos plus correct curator name: legendary legacy ending
    func ending(for curatorAnswer: String) -> GameEnding {
        let solvedCuratorName = isCuratorAnswerCorrect(curatorAnswer)
        
        if photographedSymbolCount == totalPhotoSymbolCount && solvedCuratorName {
            return .legendaryLegacy
        }
        
        switch photographedSymbolCount {
        case 9...10:
            return .museumSaved
            
        case 6...8:
            return .partialExhibit
            
        default:
            return .museumLost
        }
    }
}
