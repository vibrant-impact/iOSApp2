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
            
            VStack(spacing: 22) {
                Spacer()
                
                titleSection
                
                banner
                
                storyCard
                
                featureCards
                
                Spacer()
                
                actionButtons
            }
            .padding()
        }
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
                .background(Color(red: 6 / 255, green: 24 / 255, blue: 51 / 255))
        }
    }
    
    
    // MARK: - Background
    
    /// Background for the welcome screen.
    private var welcomeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 6 / 255, green: 24 / 255, blue: 51 / 255),
                    Color(red: 159/255, green: 188/255, blue: 229/255),
                    Color(red: 20/255, green: 82/255, blue: 128/255)
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
                    .font(.system(size: 150))
                    .foregroundStyle(Color.white.opacity(0.20))
                    .padding(.top, -10)
                
                Spacer()
            }
        }
    }
    
    
    // MARK: - Title Section
    
    /// Main title and subtitle.
    private var titleSection: some View {
        VStack(spacing: 9) {
            Spacer()
            
            Text("The Curator’s")
                .font(.title2.bold())
                .foregroundStyle(Color.white.opacity(0.9))
            
            Text("Banff Mystery")
                .font(.system(size: 46, weight: .black, design: .serif))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .shadow(color: Color.black.opacity(0.65), radius: 8, x: 0, y: 4)
            
            Text("A story-driven scavenger hunt through Banff")
                .font(.subheadline.bold())
                .foregroundStyle(Color.white.opacity(0.78))
                .multilineTextAlignment(.center)
        }
    }
    
    private var banner: some View {
      
        Image("welcomeBanner")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity) // Forces it to take up the full available width
            .clipShape(.rect(cornerRadius: 22))
            .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.blue, lineWidth: 1) )
    }
    // MARK: - Story Card
    
    /// Short story setup for the player.
    private var storyCard: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Image(systemName: "quote.opening")
                    .foregroundStyle(Color.yellow)
                
                Text("Curator’s Message")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            
            Text("""
            Research key historical sites across Banff, and photograph its history before the museum’s story disappears for good.
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
        HStack(spacing: 6) {
            
            WelcomeFeatureRow(
                icon: "map.fill",
                titleTop: "Gather",
                titleBottom: "Research",
                subtitle: "Use the corkboard to investigate locations."
            )
           
            WelcomeFeatureRow(
                icon: "magnifyingglass",
                titleTop: "Collect",
                titleBottom: "Items",
                subtitle: "Find useful tools and story leads."
            )
            
            WelcomeFeatureRow(
                icon: "camera.fill",
                titleTop: "Take",
                titleBottom: "Photos",
                subtitle: "Snap photos to unlock discount codes."
            )
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        
    }
    
    
    // MARK: - Buttons
    
    /// Main welcome screen buttons.
    private var actionButtons: some View {
        VStack(spacing: 11) {
            
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
            
            Text("Banff Park Museum Historical Scavenger Hunt")
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
    let titleTop: String
    let titleBottom: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 11) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.yellow)
                .frame(width: 34)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(titleTop)
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(titleBottom)
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .center)
                
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
                        text: "Inside the museum, tap the corkboard to choose story leads and visit Banff locations."
                    )
                    
                    instructionSection(
                        icon: "backpack.fill",
                        title: "2. Collect Tools and Notes",
                        text: "Tap objects in each scene. Some investigation may require inventory items, such as a shovel or crowbar."
                    )
                    
                    instructionSection(
                        icon: "camera.fill",
                        title: "3. Photograph Banff's History",
                        text: "Many locations have photos. Find and take these photos to reveal puzzle clues and unlock discount rewards and endings."
                    )
                    
                    instructionSection(
                        icon: "textformat.abc",
                        title: "4. Solve the Curator’s Puzzle",
                        text: "Each photo reveals one red-circled letter. Collect and unscramble all 9 letters to solve the curator’s puzzle and qualify for the grand prize draw."
                    )
                    
                    instructionSection(
                        icon: "gift.fill",
                        title: "5. Submit Your Results",
                        text: "At the end, submit your results. Photographing 5 to 6 photos unlocks a 10% discount. Photographing 7 to 9 unlocks a 20% discount. All 9 plus the curator’s puzzle solution unlocks the grand prize entry."
                    )
                }
                .padding()
            }
            .navigationTitle("How to Play")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        SoundManager.shared.play(.close, volume: 0.45)
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
            .frame(maxWidth: .infinity)
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
