//
//  MuseumInteriorView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI
import Combine

/// MuseumInteriorView is the main hub inside the museum.
///
/// The background image should include:
/// - the museum interior
/// - the curator
/// - the corkboard
///
/// The corkboard is clickable. When tapped, it opens a close-up
/// full-screen corkboard view where the player can select story leads.
struct MuseumInteriorView: View {
    
    // MARK: - Shared Game State
    
    /// Global game state shared across the app.
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - View State
    
    /// Shows the inventory/bag sheet.
    @State private var showingInventory = false
    
    /// Shows the evidence list sheet.
    @State private var showingEvidence = false
    
    /// Shows the final scavenger hunt submission screen.
    @State private var showingSubmission = false
    
    /// Shows the corkboard close-up screen.
    @State private var showingCorkboardCloseup = false
    
    /// Opens the fake camera when this contains a photo symbol.
    @State private var activePhotoSymbol: PhotoSymbol?
    
    /// Controls simple alert popups.
    @State private var showingAlert = false
    
    /// Alert title.
    @State private var alertTitle = ""
    
    /// Alert message.
    @State private var alertMessage = ""
    
    
    // MARK: - Scene Setup
    
    /// The original size of your vertical background artwork.
    ///
    /// Hotspot coordinates are based on this canvas size.
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    /// Tappable areas on the museum interior image.
    ///
    /// These are approximate. Adjust the rectangles later to match your art.
    private let hotspots: [SceneHotspot] = [
        
        // Main corkboard hotspot.
        // Tapping this opens the close-up CorkboardView.
        SceneHotspot(
            id: "corkboard",
            name: "Corkboard",
            rect: CGRect(x: 190, y: 520, width: 900, height: 1030)
        ),
        
        // Curator hotspot.
        // Tapping this gives a short reminder from the curator.
        SceneHotspot(
            id: "curator",
            name: "Curator",
            rect: CGRect(x: 380, y: 1500, width: 520, height: 540)
        ),
        
        // Optional photo scavenger hunt hotspot.
        // This counts toward endings and discount rewards.
        SceneHotspot(
            id: "photo_symbol",
            name: "Photo Symbol",
            rect: CGRect(x: 535, y: 2050, width: 220, height: 220)
        ),
        
        // Optional evidence table hotspot.
        SceneHotspot(
            id: "evidence_table",
            name: "Evidence Table",
            rect: CGRect(x: 120, y: 2150, width: 380, height: 350)
        ),
        
        // Optional submission hotspot.
        SceneHotspot(
            id: "submit_results",
            name: "Submit Results",
            rect: CGRect(x: 790, y: 2150, width: 380, height: 350)
        )
    ]
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Background image and clickable hotspot system.
            ImageSceneView(
                imageName: "museum_interior",
                canvasSize: canvasSize,
                hotspots: hotspots,
                
                // Set this to true while positioning hotspots.
                // Change to false later for the polished version.
                showDebugHotspots: true,
                
                onHotspotTapped: handleHotspotTapped
            )
            
            // Dark gradients make the top and bottom UI easier to read.
            readabilityGradients
            
            // Top HUD.
            VStack {
                topBar
                    .padding(.horizontal)
                    .padding(.top, 12)
                
                Spacer()
                
                bottomControls
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
        }
        
        // Inventory sheet.
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        // Evidence sheet.
        .sheet(isPresented: $showingEvidence) {
            EvidenceListView()
                .environmentObject(gameState)
                .presentationDetents([.medium, .large])
        }
        
        // Submission / ending sheet.
        .sheet(isPresented: $showingSubmission) {
            EndingSubmissionView()
                .environmentObject(gameState)
        }
        
        // Full-screen corkboard close-up.
        .fullScreenCover(isPresented: $showingCorkboardCloseup) {
            MuseumCorkboardCloseupView()
                .environmentObject(gameState)
        }
        
        // Fake camera view for the optional museum photo symbol.
        .fullScreenCover(item: $activePhotoSymbol) { symbol in
            FakeCameraView(
                symbol: symbol,
                alreadyCaptured: gameState.hasPhotographedSymbol(symbol.id),
                onCapture: { capturedSymbol in
                    gameState.photographSymbol(capturedSymbol)
                }
            )
        }
        
        // General museum alerts.
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    
    // MARK: - Readability Gradients
    
    /// Adds subtle dark overlays at the top and bottom so buttons remain readable.
    private var readabilityGradients: some View {
        VStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.72),
                    Color.black.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
            
            Spacer()
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.78)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 360)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
    
    
    // MARK: - Top Bar
    
    /// Top navigation bar with title, evidence button, and inventory button.
    private var topBar: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Banff Museum")
                    .font(.title.bold())
                    .foregroundStyle(Color.white)
                
                Text("Curator’s Investigation Room")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.75))
            }
            
            Spacer()
            
            Button {
                showingEvidence = true
            } label: {
                Label("Evidence", systemImage: "doc.text.magnifyingglass")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
            .tint(Color.yellow)
            
            Button {
                showingInventory = true
            } label: {
                Label("Bag", systemImage: "backpack.fill")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
            .tint(Color.orange)
        }
    }
    
    
    // MARK: - Bottom Controls
    
    /// Bottom controls for major hub actions.
    private var bottomControls: some View {
        VStack(spacing: 12) {
            
            // Hint telling the player what to do.
            Text("Tap the corkboard to choose your next lead.")
                .font(.headline)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.55))
                .clipShape(Capsule())
            
            HStack(spacing: 12) {
                
                // Opens the corkboard close-up.
                Button {
                    showingCorkboardCloseup = true
                } label: {
                    Label("Corkboard", systemImage: "pin.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                // Opens the final/scavenger hunt submission screen.
                Button {
                    showingSubmission = true
                } label: {
                    Label("Submit", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 12) {
                
                // Optional museum interior photo symbol.
                Button {
                    activePhotoSymbol = .museumInterior
                } label: {
                    Label("Photo Symbol", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                // Return outside.
                Button {
                    gameState.currentLocation = .museumExterior
                } label: {
                    Label("Outside", systemImage: "door.right.hand.open")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    /// Routes tapped hotspots to the correct interaction.
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
            
        case "corkboard":
            showingCorkboardCloseup = true
            
        case "curator":
            showCuratorReminder()
            
        case "photo_symbol":
            activePhotoSymbol = .museumInterior
            
        case "evidence_table":
            showingEvidence = true
            
        case "submit_results":
            showingSubmission = true
            
        default:
            break
        }
    }
    
    
    // MARK: - Curator Text
    
    /// Shows a short curator reminder when the curator is tapped.
    private func showCuratorReminder() {
        showAlert(
            title: "The Museum Curator",
            message: """
            “The corkboard has everything we know so far.

            Follow the leads, bring back evidence, and keep an eye out for historical symbols. Those photographs may decide whether the museum survives.”
            """
        )
    }
    
    
    // MARK: - Alert Helper
    
    /// Convenience function for showing alerts.
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


// MARK: - Corkboard Close-Up View

/// Full-screen close-up of the museum corkboard.
///
/// This view makes the corkboard feel like an interactable object
/// rather than just a regular menu.
private struct MuseumCorkboardCloseupView: View {
    
    // MARK: - Shared Game State
    
    @EnvironmentObject private var gameState: GameState
    
    // MARK: - Dismiss
    
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Warm corkboard-style background.
            corkboardBackground
            
            VStack(spacing: 16) {
                
                // Header.
                header
                
                // Main corkboard content.
                ScrollView {
                    VStack(spacing: 18) {
                        
                        curatorNote
                        
                        CorkboardView()
                            .environmentObject(gameState)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Background
    
    /// Creates a warm background that feels like a zoomed-in corkboard.
    private var corkboardBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.17, blue: 0.08),
                    Color(red: 0.58, green: 0.36, blue: 0.17),
                    Color(red: 0.24, green: 0.13, blue: 0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle paper/cork texture effect.
            Rectangle()
                .fill(Color.black.opacity(0.15))
                .blendMode(.multiply)
        }
        .ignoresSafeArea()
    }
    
    
    // MARK: - Header
    
    /// Top bar for the close-up corkboard screen.
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("The Curator’s Corkboard")
                    .font(.title.bold())
                    .foregroundStyle(Color.white)
                
                Text("Choose a lead to investigate.")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.75))
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white.opacity(0.9))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.black.opacity(0.28))
    }
    
    
    // MARK: - Curator Note
    
    /// Intro note shown above the corkboard cards.
    private var curatorNote: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundStyle(Color.red)
                
                Text("Curator’s Note")
                    .font(.headline)
                    .foregroundStyle(Color.black)
                
                Spacer()
            }
            
            Text("""
            Three early leads are pinned here first. Complete them, recover the submerged clue, and new locations will become available.

            Optional photo symbols are hidden throughout Banff. They are not required for the story, but they affect the museum’s ending and the discount rewards.
            """)
            .font(.subheadline)
            .foregroundStyle(Color.black.opacity(0.82))
        }
        .padding()
        .background(
            Color(red: 0.96, green: 0.86, blue: 0.62)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


// MARK: - Preview

#Preview {
    MuseumInteriorView()
        .environmentObject(GameState())
}
