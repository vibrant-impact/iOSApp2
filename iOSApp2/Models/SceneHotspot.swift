//
//  SceneHotspot.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import Foundation
import CoreGraphics

/// Represents a tappable area on top of a scene image.
struct SceneHotspot: Identifiable {
    
    let id: String
    let name: String
    let rect: CGRect
}
