//
//  SceneOverlayObject.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-11.
//

import Foundation

/// Represents a state change after a hotspot has been acted upon
struct SceneOverlayObject: Identifiable {
    let id: String
    let imageName: String
    let rect: CGRect
}
