//
//  SnowfallOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct SnowfallOverlay: View {
    private let flakes = Array(0..<45)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(flakes, id: \.self) { _ in
                    Circle()
                        .fill(.white.opacity(Double.random(in: 0.25...0.75)))
                        .frame(
                            width: CGFloat.random(in: 2...5),
                            height: CGFloat.random(in: 2...5)
                        )
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        SnowfallOverlay()
    }
}
