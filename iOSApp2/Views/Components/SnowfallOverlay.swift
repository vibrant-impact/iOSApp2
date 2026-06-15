//
//  SnowfallOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct SnowfallOverlay: View {
    
    private let flakes: [Snowflake] = Snowflake.makeFlakes(count: 60)
    
    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geo in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                ZStack {
                    ForEach(flakes) { flake in
                        Circle()
                            .fill(.white.opacity(flake.opacity))
                            .frame(width: flake.size, height: flake.size)
                            .position(
                                x: xPosition(for: flake, time: time, width: geo.size.width),
                                y: yPosition(for: flake, time: time, height: geo.size.height)
                            )
                    }
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
    
    private func xPosition(for flake: Snowflake, time: TimeInterval, width: CGFloat) -> CGFloat {
        let drift = sin(time * flake.driftSpeed + flake.phase) * flake.driftAmount
        return flake.xRatio * width + drift
    }
    
    private func yPosition(for flake: Snowflake, time: TimeInterval, height: CGFloat) -> CGFloat {
        let rawY = flake.yRatio * height + CGFloat(time * flake.fallSpeed).truncatingRemainder(dividingBy: height + 80)
        return rawY - 40
    }
}

private struct Snowflake: Identifiable {
    let id = UUID()
    let xRatio: CGFloat
    let yRatio: CGFloat
    let size: CGFloat
    let opacity: Double
    let fallSpeed: Double
    let driftSpeed: Double
    let driftAmount: CGFloat
    let phase: Double
    
    static func makeFlakes(count: Int) -> [Snowflake] {
        (0..<count).map { index in
            Snowflake(
                xRatio: CGFloat.random(in: 0...1),
                yRatio: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.22...0.78),
                fallSpeed: Double.random(in: 18...52),
                driftSpeed: Double.random(in: 0.4...1.3),
                driftAmount: CGFloat.random(in: 8...34),
                phase: Double(index) * 0.7
            )
        }
    }
}
