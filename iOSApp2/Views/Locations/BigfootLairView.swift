//
//  BigfootLairView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-08.
//

import SwiftUI

import SwiftUI

struct BigfootLairView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var activeOverlay: BigfootLairOverlay?
    @State private var showingBigfootCamera = false
    @State private var showingFinalBlackout = false
    
    @State private var wakeUpBlur: CGFloat = 18
    @State private var wakeUpBlackOpacity = 1.0
    @State private var wakeUpTextOpacity = 0.0
    @State private var isShowingWakeUpSequence = true
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "cave_exit",
            name: "Cave Entrance Above",
            rect: CGRect(x: 338, y: 222, width: 759, height: 661)
        ),
        SceneHotspot(
            id: "bigfoot_family",
            name: "Bigfoot Family",
            rect: CGRect(x: 145, y: 1725, width: 662, height: 721)
        ),
        SceneHotspot(
            id: "lost_lemon_mine",
            name: "Lost Lemon Mine",
            rect: CGRect(x: 13, y: 981, width: 515, height: 665)
        ),
        SceneHotspot(
            id: "bigfoot",
            name: "Bigfoot",
            rect: CGRect(x: 787, y: 1292, width: 374, height: 666)
        )
    ]
    
    var body: some View {
        ZStack {
            lairContent
                .blur(radius: wakeUpBlur)
            
            if isShowingWakeUpSequence {
                wakeUpFromBlackOverlay
            }
        }
        .onAppear {
            runWakeUpSequence()
        }
        .fullScreenCover(isPresented: $showingBigfootCamera) {
            BigfootEvidenceCameraView {
                gameState.hasTakenBigfootEvidencePhoto = true
                checkForLairCompletion()
            }
        }
    }
    
    private var lairContent: some View {
        ZStack {
            ImageSceneView(
                imageName: "bigfoot_lair_base",
                canvasSize: canvasSize,
                hotspots: hotspots,
                overlayObjects: [],
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            lairTitle
            
            if let activeOverlay {
                overlayView(for: activeOverlay)
            }
            
            if showingFinalBlackout {
                BigfootLairBlackoutView {
                    gameState.finishBigfootLairSequence()
                }
            }
        }
        .fullScreenCover(isPresented: $showingBigfootCamera) {
            BigfootEvidenceCameraView {
                gameState.hasTakenBigfootEvidencePhoto = true
                checkForLairCompletion()
            }
        }
    }
    
    private var lairTitle: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unknown Cave")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text("You are hurt, disoriented, and unsure of your location.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.75))
                }
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            Spacer()
        }
    }
    
    private var wakeUpFromBlackOverlay: some View {
        ZStack {
            Color.black
                .opacity(wakeUpBlackOpacity)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("Your eyes open slowly.")
                Text("Stone. Cold air. A distant drip of water.")
                Text("You are not on Tunnel Mountain anymore.")
            }
            .font(.headline)
            .foregroundStyle(.white.opacity(0.92))
            .multilineTextAlignment(.center)
            .padding()
            .opacity(wakeUpTextOpacity)
        }
        .allowsHitTesting(true)
    }
    
    private func runWakeUpSequence() {
        guard isShowingWakeUpSequence else {
            return
        }
        
        SoundManager.shared.play(.lairWakeup, volume: 0.55)
        
        wakeUpBlur = 18
        wakeUpBlackOpacity = 1.0
        wakeUpTextOpacity = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeInOut(duration: 0.9)) {
                wakeUpTextOpacity = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut(duration: 2.2)) {
                wakeUpBlackOpacity = 0.35
                wakeUpBlur = 8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            withAnimation(.easeInOut(duration: 1.8)) {
                wakeUpBlackOpacity = 0.0
                wakeUpBlur = 0
                wakeUpTextOpacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.8) {
            isShowingWakeUpSequence = false
        }
    }
    
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "cave_exit":
            gameState.hasInspectedLairExit = true
            activeOverlay = .caveExit
            
        case "bigfoot_family":
            gameState.hasMetBigfootFamily = true
            activeOverlay = .bigfootFamily
            
        case "lost_lemon_mine":
            gameState.hasInspectedLostLemonMine = true
            activeOverlay = .lostLemonMine
            
        case "bigfoot":
            showingBigfootCamera = true
            
        default:
            break
        }
    }
    
    private func checkForLairCompletion() {
        guard gameState.hasCompletedRequiredLairInteractions else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showingFinalBlackout = true
        }
    }
    
    @ViewBuilder
    private func overlayView(for overlay: BigfootLairOverlay) -> some View {
        switch overlay {
        case .caveExit:
            HotspotZoomOverlay(
                title: "The Way Out",
                imageName: "zoom_lair_cave_exit",
                description: """
                Far above you, cold daylight spills through a jagged opening in the rock.

                You have no idea where you are.

                Your head aches. Your shoulder burns. Even if you could reach the wall, you are in no condition to climb out.
                """,
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeOverlay = nil
                    checkForLairCompletion()
                },
                onClose: {
                    activeOverlay = nil
                    checkForLairCompletion()
                }
            )
            
        case .bigfootFamily:
            HotspotZoomOverlay(
                title: "Gentle Hands",
                imageName: "zoom_lair_bigfoot_family",
                description: """
                A smaller Bigfoot seems eager to help while another carefully arranges old first aid supplies.

                Bandages. A dented tin. Meltwater in a cup.

                They did not bring you here as a prisoner.

                They brought you here because you were hurt.
                """,
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeOverlay = nil
                    checkForLairCompletion()
                },
                onClose: {
                    activeOverlay = nil
                    checkForLairCompletion()
                }
            )
            
        case .lostLemonMine:
            HotspotZoomOverlay(
                title: "The Lost Lemon Mine",
                imageName: "zoom_lair_lost_lemon_mine",
                description: """
                Beyond the cavern wall, a mine opening glitters with an unmistakable shine.

                I can't believe my eyes! Am I dreaming? A faded mark is scratched onto the entrance rocks:

                LEMON

                """,
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeOverlay = nil
                    checkForLairCompletion()
                },
                onClose: {
                    activeOverlay = nil
                    checkForLairCompletion()
                }
            )
        }
    }
}

private enum BigfootLairOverlay: Identifiable {
    case caveExit
    case bigfootFamily
    case lostLemonMine
    
    var id: String {
        String(describing: self)
    }
}

// MARK: - Preview

#Preview {
    BigfootLairView()
        .environmentObject(GameState())
}
