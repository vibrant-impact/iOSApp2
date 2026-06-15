//
//  WelcomeView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

/// WelcomeView is the first screen the player sees.
struct WelcomeView: View {
    
    // MARK: - Shared Game State
    
    /// Global game state shared across the app.
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - View State
    
    /// Shows the "How to Play" instructions sheet.
    @State private var showingHowToPlay = false
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            // Main atmospheric background.
            welcomeBackground
            
            // Dark overlay for readability.
            Color.black.opacity(0.28)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                titleSection
                
                storyCard
                
                featureCards
                
                Spacer()
                
                actionButtons
            }
            .padding()
        }
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
        }
    }
    
    
    // MARK: - Background
    
    /// Background for the welcome screen.
    private var welcomeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.06, blue: 0.10),
                    Color(red: 0.10, green: 0.08, blue: 0.05),
                    Color(red: 0.22, green: 0.14, blue: 0.07)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Subtle spotlight glow.
            RadialGradient(
                colors: [
                    Color.yellow.opacity(0.30),
                    Color.orange.opacity(0.08),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 420
            )
            .ignoresSafeArea()
            
            // Decorative mountain/moon icon area.
            VStack {
                Image(systemName: "mountain.2.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(Color.white.opacity(0.10))
                    .padding(.top, 70)
                
                Spacer()
            }
        }
    }
    
    
    // MARK: - Title Section
    
    /// Main title and subtitle.
    private var titleSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 58))
                .foregroundStyle(Color.yellow)
                .shadow(radius: 8)
            
            Text("The Curator’s")
                .font(.title2.bold())
                .foregroundStyle(Color.white.opacity(0.9))
            
            Text("Banff Mystery")
                .font(.system(size: 46, weight: .black, design: .serif))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .shadow(color: Color.black.opacity(0.65), radius: 8, x: 0, y: 4)
            
            Text("A story-driven scavenger hunt through Banff history")
                .font(.subheadline.bold())
                .foregroundStyle(Color.white.opacity(0.78))
                .multilineTextAlignment(.center)
        }
    }
    
    
    // MARK: - Story Card
    
    /// Short story setup for the player.
    private var storyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .foregroundStyle(Color.yellow)
                
                Text("Curator’s Message")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            
            Text("""
            The museum is running out of time.

            Follow the curator’s leads, gather story leads across Banff, and photograph its history before the museum’s story disappears for good.
            """)
            .font(.body)
            .foregroundStyle(Color.white.opacity(0.86))
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.black.opacity(0.48))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
    }
    
    
    // MARK: - Feature Cards
    
    /// Small feature cards explaining the core gameplay.
    private var featureCards: some View {
        VStack(spacing: 10) {
            WelcomeFeatureRow(
                icon: "map.fill",
                title: "Follow the Leads",
                subtitle: "Use the corkboard to investigate Banff locations."
            )
            
            WelcomeFeatureRow(
                icon: "magnifyingglass",
                title: "Collect Inventory Items",
                subtitle: "Find historical points of interest, tools, and story leads."
            )
            
            WelcomeFeatureRow(
                icon: "camera.fill",
                title: "Photos",
                subtitle: "Optional photos unlock discounts, endings, and the grand prize clue."
            )
        }
    }
    
    
    // MARK: - Buttons
    
    /// Main welcome screen buttons.
    private var actionButtons: some View {
        VStack(spacing: 12) {
            
            Button {
                startGame()
            } label: {
                Label("Begin Investigation", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.yellow)
            .foregroundStyle(Color.black)
            
            Button {
                showingHowToPlay = true
            } label: {
                Label("How to Play", systemImage: "questionmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(Color.white)
            
            Text("Banff Museum Historical Scavenger Hunt")
                .font(.caption)
                .foregroundStyle(Color.white.opacity(0.55))
                .padding(.top, 4)
        }
    }
    
    
    // MARK: - Start Game
    
    /// Starts the game and sends the player to the museum exterior.
    private func startGame() {
        gameState.currentLocation = .museumExterior
        gameState.hasStartedGame = true
    }
}


// MARK: - Feature Row

/// A reusable row used on the welcome screen to explain gameplay features.
private struct WelcomeFeatureRow: View {
    
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.yellow)
                .frame(width: 34)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.72))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


// MARK: - How To Play Sheet

/// Explains the rules of the game in assignment-friendly language.
private struct HowToPlayView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    instructionSection(
                        icon: "pin.fill",
                        title: "1. Use the Corkboard",
                        text: "Inside the museum, tap the corkboard to choose story leads. Some locations unlock only after earlier locations are explored."
                    )
                    
                    instructionSection(
                        icon: "backpack.fill",
                        title: "2. Collect Tools and Notes",
                        text: "Tap objects in each scene. Some investigation may require inventory items, such as a shovel or crowbar."
                    )
                    
                    instructionSection(
                        icon: "camera.fill",
                        title: "3. Photograph Banff's History",
                        text: "Each location has an optional photo. These are not required for the main story, but they affect the discount rewards and endings."
                    )
                    
                    instructionSection(
                        icon: "textformat.abc",
                        title: "4. Solve the Curator’s Puzzle",
                        text: "Each photo reveals one red-circled letter. Collect and unscramble all 9 letters to solve the curator’s puzzle and qualify for the grand prize draw."
                    )
                    
                    instructionSection(
                        icon: "gift.fill",
                        title: "5. Submit Your Results",
                        text: "At the end, submit your results. Photographing 5 to 6 photos unlocks a 10% discount. Photographing 7 or 8 unlocks a 20% discount. All 9 plus the curator’s puzzle solution unlocks the grand prize entry."
                    )
                }
                .padding()
            }
            .navigationTitle("How to Play")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    /// Creates one instruction block.
    private func instructionSection(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.yellow)
                .frame(width: 34)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(text)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}


// MARK: - Preview

#Preview {
    WelcomeView()
        .environmentObject(GameState())
}
