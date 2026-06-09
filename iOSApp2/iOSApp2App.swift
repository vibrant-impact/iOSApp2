//
//  iOSApp2App.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// The main entry point for the Heart of the Wild app.
@main
struct HeartOfTheWildApp: App {
    
    /// The shared game state for the entire app.
    ///
    /// `@StateObject` creates and owns one persistent instance of `GameState`
    /// for the lifetime of the app.

    @StateObject private var gameState = GameState()
    
    
    // MARK: - App Scene
    
    /// The main scene displayed by the app.
    ///
    /// `WindowGroup` is the standard SwiftUI scene container for an app window.
    /// On iPhone, this usually represents the single full-screen app window.
    var body: some Scene {
        WindowGroup {
            
            // `ContentView` is the root view of the app.
            //
            // The shared `gameState` is injected into the SwiftUI environment
            // so any child view with:
            //
            // `@EnvironmentObject private var gameState: GameState`
            //
            // can access and update the same game progress.
            ContentView()
                .environmentObject(gameState)
        }
    }
}
