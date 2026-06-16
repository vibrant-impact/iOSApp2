//
//  HapticsManager.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() { }
    
    func lightTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func mediumTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func heavyImpact() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}
