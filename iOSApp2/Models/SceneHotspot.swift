//
//  SceneHotspot.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation
import CoreGraphics

/// Represents a tappable area on top of a scene image.
///
/// A `SceneHotspot` is used to make parts of a background image interactive.
/// For example, the player might tap:
/// - a mailbox
/// - a museum door
/// - a sign
/// - a clue hidden in snow
/// - a strange footprint
///
/// Each hotspot has a rectangle that describes where it appears on the screen.
/// Views can loop through an array of hotspots and place invisible buttons
/// over the matching parts of the image.
struct SceneHotspot: Identifiable {
    
    /// A unique string used to identify this hotspot.
    ///
    /// This id is usually checked in a `switch` statement when the player taps
    /// the hotspot.
    ///
    /// Example:
    /// `"museum_door"`
    let id: String
    
    /// The display name or developer-friendly name of the hotspot.
    ///
    /// This can be used for accessibility labels, debugging, or future UI hints.
    ///
    /// Example:
    /// `"Museum Door"`
    let name: String
    
    /// The rectangular tappable area for this hotspot.
    ///
    /// The rectangle uses `CGRect`, which stores:
    /// - x position
    /// - y position
    /// - width
    /// - height
    ///
    /// In this project, the values are usually relative to the scene layout
    /// and are used by hotspot overlay views.
    let rect: CGRect
}
