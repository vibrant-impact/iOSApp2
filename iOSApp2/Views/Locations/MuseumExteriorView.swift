//
//  MuseumExteriorView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct MuseumExteriorView: View {
    
    @EnvironmentObject private var gameState: GameState
    
    
    // MARK: - State
    
    @State private var showingDoorLock = false
    @State private var showingInventory = false
    @State private var showingJournal = false
    
    @State private var simpleAlertTitle = ""
    @State private var simpleAlertMessage = ""
    @State private var showingSimpleAlert = false
    
    @State private var activePhoto: Photo?
    @State private var activeZoomOverlay: MuseumExteriorZoomOverlay?
    @State private var collectedItemOverlay: InventoryItem?
    
    @State private var museumWakeBlur: CGFloat = 18
    @State private var museumWakeBlackOpacity = 0.0
    @State private var museumWakeTextOpacity = 0.0

    @State private var isShowingMuseumWakeOverlay = false
    @State private var isShowingHeadHurtsAlert = false
    @State private var isShowingPocketGoldOverlay = false
    
    // MARK: - Scene Data
    
    private let canvasSize = CGSize(width: 1290, height: 2796)
    
    private let hotspots: [SceneHotspot] = [
        SceneHotspot(
            id: "mailbox",
            name: "Mailbox",
            rect: CGRect(x: 13, y: 1871, width: 354, height: 245)
        ),
        SceneHotspot(
            id: "footprint",
            name: "Massive Mysterious Footprint",
            rect: CGRect(x: 340, y: 2390, width: 317, height: 328)
        ),
        SceneHotspot(
            id: "shovel",
            name: "Small Shovel",
            rect: CGRect(x: 992, y: 2291, width: 197, height: 266)
        ),
        SceneHotspot(
            id: "sign",
            name: "Museum Sign",
            rect: CGRect(x: 495, y: 1303, width: 471, height: 222)
        ),
        SceneHotspot(
            id: "door",
            name: "Museum Door",
            rect: CGRect(x: 719, y: 1674, width: 149, height: 206)
        ),
        SceneHotspot(
            id: "sled",
            name: "Sled",
            rect: CGRect(x: 854, y: 1797, width: 189, height: 291)
        ),
        SceneHotspot(
            id: "rabbit",
            name: "Rabbit",
            rect: CGRect(x: 68, y: 1713, width: 116, height: 124)
        ),
        SceneHotspot(
            id: "birdhouse",
            name: "Birdhouse",
            rect: CGRect(x: 1136, y: 701, width: 151, height: 184)
        )
    ]
    
    
    // MARK: - Active Scene Layers
    
    private var activeHotspots: [SceneHotspot] {
        hotspots.filter { hotspot in
            switch hotspot.id {
            case "shovel":
                return !gameState.hasCollectedShovel
            default:
                return true
            }
        }
    }
    
    private var activeOverlayObjects: [SceneOverlayObject] {
        var overlays: [SceneOverlayObject] = []
        
        if gameState.hasOpenedMailbox {
            overlays.append(
                SceneOverlayObject(
                    id: "mailbox_open",
                    imageName: "museum_mailbox_open_overlay",
                    rect: CGRect(x: 187, y: 1909, width: 253, height: 312)
                )
            )
        }
        
        if gameState.hasCollectedShovel {
            overlays.append(
                SceneOverlayObject(
                    id: "shovel_gone",
                    imageName: "museum_shovel_gone_overlay",
                    rect: CGRect(x: 970, y: 2289, width: 236, height: 287)
                )
            )
        }
        
        return overlays
    }
    
    // MARK: - museum body
    var body: some View {
        ZStack {
            museumExteriorContent
                .blur(radius: museumWakeBlur)
            
            if isShowingMuseumWakeOverlay {
                museumWakeUpOverlay
            }
            
            if isShowingPocketGoldOverlay {
                PocketGoldNuggetOverlay {
                    collectPocketGoldNugget()
                }
                .zIndex(20)
            }
        }
        .onAppear {
            startMuseumExteriorAmbience()
            runMuseumWakeUpIfNeeded()
        }
        .onDisappear {
            SoundManager.shared.stopAmbience(.snowyExterior)
        }
        .alert("Your head aches.", isPresented: $isShowingHeadHurtsAlert) {
            Button("Check Pocket") {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isShowingPocketGoldOverlay = true
                    }
                }
            }
            
        } message: {
            Text("""
            Cold stone. Falling ice. A shadow in the dark.

            Was it a dream?

            You swear you saw Bigfoot… and the Lost Lemon Mine.
            """)
        }
    }
    
    // MARK: - museum
    
    private var museumExteriorContent: some View {
        ZStack {
            ImageSceneView(
                imageName: "museum_exterior_base",
                canvasSize: canvasSize,
                hotspots: activeHotspots,
                overlayObjects: activeOverlayObjects,
                showDebugHotspots: false,
                onHotspotTapped: handleHotspotTapped
            )
            
            SnowfallOverlay()
            
            TopHUDView(
                locationTitle: "Discover Banff",
                locationSubtitle: "Legends and Lore",
                onBagTapped: {
                    showingInventory = true
                },
                onJournalTapped: {
                    showingJournal = true
                }
            )
            
            if let activeZoomOverlay {
                zoomOverlay(for: activeZoomOverlay)
            }
            
            if let collectedItemOverlay {
                ItemCollectedOverlay(item: collectedItemOverlay) {
                    self.collectedItemOverlay = nil
                }
            }
        }
        .sheet(isPresented: $showingDoorLock) {
            CombinationLockView(
                correctCode: "1903",
                onUnlock: {
                    SoundManager.shared.play(.doorUnlock)
                    
                    gameState.isMuseumDoorUnlocked = true
                    showingDoorLock = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        gameState.currentLocation = .museumInterior
                    }
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingInventory) {
            InventoryView()
                .environmentObject(gameState)
                .presentationDetents([.medium])
        }
        
        .sheet(isPresented: $showingJournal) {
            JournalView()
                .environmentObject(gameState)
                .presentationDetents([.medium, .large])
        }
        
        .alert(simpleAlertTitle, isPresented: $showingSimpleAlert) {
            Button("OK") { }
        } message: {
            Text(simpleAlertMessage)
        }
        .fullScreenCover(item: $activePhoto) { photo in
            FakeCameraView(
                photo: photo,
                alreadyCaptured: gameState.hasPhoto(photo),
                onCapture: { capturedPhoto in
                    gameState.capturePhoto(capturedPhoto)
                }
            )
        }
    }
    
    
    // MARK: - Hotspot Handling
    
    private func handleHotspotTapped(_ hotspot: SceneHotspot) {
        switch hotspot.id {
        case "mailbox":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = gameState.hasOpenedMailbox ? .mailboxOpen : .mailboxClosed
            
        case "shovel":
            SoundManager.shared.play(.tap, volume: 0.35)
            activeZoomOverlay = .shovel
            
        case "footprint":
            activePhoto = Photo.museumExterior
            
        case "sign":
            activeZoomOverlay = .sign
            
        case "door":
            SoundManager.shared.play(.tap, volume: 0.35)
            if gameState.isMuseumDoorUnlocked {
                gameState.currentLocation = .museumInterior
            } else {
                activeZoomOverlay = .door
            }
            
        case "sled":
            showSimpleAlert(
                title: "Old Sled",
                message: "An old wooden sled rests in the snow, worn smooth from years of winter use."
            )
            
        case "rabbit":
            showSimpleAlert(
                title: "Snowshoe Hare",
                message: "A snowshoe hare watches you from the edge of the museum grounds, perfectly still against the winter quiet."
            )
            
        case "birdhouse":
            showSimpleAlert(
                title: "Birdhouse",
                message: "A tiny birdhouse hangs above the snow, its entrance rimmed with frost."
            )
            
        default:
            break
        }
    }
    
    private func showSimpleAlert(title: String, message: String) {
        simpleAlertTitle = title
        simpleAlertMessage = message
        showingSimpleAlert = true
    }
    
    
    // MARK: - Zoom Overlays
    
    @ViewBuilder
    private func zoomOverlay(for overlay: MuseumExteriorZoomOverlay) -> some View {
        switch overlay {
        
        case .mailboxClosed:
            HotspotZoomOverlay(
                title: "Mailbox",
                imageName: "zoom_museum_mailbox_open",
                description: "There's a letter inside with your name on it.",
                primaryButtonTitle: "Read Letter",
                onPrimaryAction: {
                    gameState.hasOpenedMailbox = true
                    activeZoomOverlay = .mailboxOpen
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .mailboxOpen:
            HotspotZoomOverlay(
                title: "The Curator's Note",
                imageName: "zoom_museum_mailbox_open",
                description: """
                Welcome to Banff.

                I am glad your camera is ready, because this museum is running out of time.

                Make your way through Banff and gather what you need to write the ultimate story — one that can revive public interest and save the museum from closure.

                I believe you are the one who can answer the question I never could:

                Who guards the Lost Lemon Mine?

                History holds the key to the door.

                — The Museum Curator
                """,
                
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    gameState.hasReadMailboxNote = true
                    activeZoomOverlay = nil
                },
                
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .shovel:
            HotspotZoomOverlay(
                title: "Small Shovel",
                imageName: "zoom_museum_shovel",
                description: "A small metal shovel leans in the snow. It could help dig through packed drifts.",
                primaryButtonTitle: "Take Shovel",
                onPrimaryAction: {
                    gameState.collectShovel()
                    activeZoomOverlay = nil
                    collectedItemOverlay = .smallShovel
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .sign:
            HotspotZoomOverlay(
                title: "Museum Sign",
                imageName: "zoom_museum_sign",
                description: "The sign marks the Banff Park Museum, built in 1903. The date feels important.",
                primaryButtonTitle: "Close",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
            
        case .door:
            HotspotZoomOverlay(
                title: "Front Door",
                imageName: "zoom_museum_door",
                description: "The museum door is locked with an old number code. The curator's note said history holds the key.",
                primaryButtonTitle: "Try the Lock",
                onPrimaryAction: {
                    activeZoomOverlay = nil
                    showingDoorLock = true
                },
                onClose: {
                    activeZoomOverlay = nil
                }
            )
        }
    }
    
    // MARK: - Wake up Overlay
    private var museumWakeUpOverlay: some View {
        ZStack {
            Color.black
                .opacity(museumWakeBlackOpacity)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("Your eyes open slowly.")
                Text("Snowlight. Cold air. The museum steps.")
                Text("You are back in Banff.")
            }
            .font(.headline)
            .foregroundStyle(.white.opacity(0.92))
            .multilineTextAlignment(.center)
            .padding()
            .opacity(museumWakeTextOpacity)
        }
        .allowsHitTesting(true)
    }
    
    // MARK: - Ambient Sound
    private func startMuseumExteriorAmbience() {
        SoundManager.shared.stopAllAmbience()
        SoundManager.shared.playAmbience(.snowyExterior, volume: 1.0)
    }
    
    // MARK: - Wake up Sequence
    private func runMuseumWakeUpIfNeeded() {
        guard gameState.shouldShowMuseumWakeUpAfterLair else {
            museumWakeBlur = 0
            museumWakeBlackOpacity = 0
            museumWakeTextOpacity = 0
            isShowingMuseumWakeOverlay = false
            return
        }
        
        gameState.shouldShowMuseumWakeUpAfterLair = false
        
        isShowingMuseumWakeOverlay = true
        museumWakeBlur = 18
        museumWakeBlackOpacity = 1.0
        museumWakeTextOpacity = 0.0
        
        SoundManager.shared.playAmbience(.snowyExterior, volume: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeInOut(duration: 0.9)) {
                museumWakeTextOpacity = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
            withAnimation(.easeInOut(duration: 2.1)) {
                museumWakeBlackOpacity = 0.25
                museumWakeBlur = 8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.55) {
            withAnimation(.easeInOut(duration: 1.6)) {
                museumWakeBlackOpacity = 0.0
                museumWakeBlur = 0
                museumWakeTextOpacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.25) {
            isShowingMuseumWakeOverlay = false
            
            guard !gameState.hasFoundGoldNuggetInPocket else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                SoundManager.shared.play(.tap, volume: 0.35)
                isShowingHeadHurtsAlert = true
            }
        }
    }
    
    
    // MARK: - Finding Gold
    private func collectPocketGoldNugget() {
        print("Collecting Lost Lemon Gold Nugget")
        
        gameState.collectInventoryItem(.lostLemonGoldNugget)
        
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowingPocketGoldOverlay = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            collectedItemOverlay = .lostLemonGoldNugget
        }
    }
}


// MARK: - Zoom Overlay Types

private enum MuseumExteriorZoomOverlay: Identifiable {
    case mailboxClosed
    case mailboxOpen
    case shovel
    case sign
    case door
    
    var id: String {
        String(describing: self)
    }
}


// MARK: - Preview

#Preview {
    MuseumExteriorView()
        .environmentObject(GameState())
}
