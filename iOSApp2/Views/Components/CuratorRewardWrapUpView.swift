//
//  CuratorRewardWrapUpView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-16.
//

import SwiftUI

struct CuratorRewardWrapUpView: View {
    
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 22) {
            Text("The Museum is Saved")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            storyCard
            
            Button {
            } label: {
                Label("Enter $5000 Grand Prize Draw", systemImage: "paperplane.fill")
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            
            rewardsCard
            
            Button {
            } label: {
                Label("Exit", systemImage: "gobackward")
            }
            .buttonStyle(.borderedProminent)
            
            
        }
        .padding(.bottom, 40)
        .onAppear {
        }
    }
    
    
    // MARK: - Story Card
    
    private var storyCard: some View {
        VStack(spacing: 12) {
            Text("""
            “Sasquatch,” the curator murmurs.

            The empty cave photograph. The small gold nugget burning like a secret in your coat pocket. Your photos and journal notes. And a bump on your noggin requiring ice!
            
            It isn’t proof that can survive scrutiny.
            It won’t open locked doors.
            It won’t guide anyone back to the lair.
            
            But it will ignite interest—
            with a story so legendary people will come hoping for their own glimpses.
            
            The museum is saved.
            """)
            .font(.body)
            .foregroundStyle(.white.opacity(0.88))
            .multilineTextAlignment(.center)
            
            Label("Grand Prize Draw Entry Unlocked", systemImage: "star.circle.fill")
                .font(.headline)
                .foregroundStyle(.yellow)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    
    // MARK: - Rewards Card
    
    private var rewardsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CONGRATULATIONS")
                .font(.title2.bold())
                .foregroundStyle(.yellow)
            
            rewardRow(
                icon: "camera.fill",
                title: "Photo Journal Complete",
                message: "\(gameState.photoCount)/\(gameState.totalPhotoCount) historical photos captured"
            )
            
            rewardRow(
                icon: "star.circle.fill",
                title: "Grand Prize Entry",
                message: "Curator puzzle solved"
            )
            
            rewardRow(
                icon: "sparkles",
                title: "Story of the Century",
                message: "You answered who guards the Lost Lemon Mine"
            )
            
            rewardRow(
                icon: "ticket.fill",
                title: "Reward Code",
                message: gameState.photoRewardCode
            )
            
            if gameState.hasFoundGoldNuggetInPocket {
                rewardRow(
                    icon: "circle.hexagongrid.fill",
                    title: "Unexpected Gift",
                    message: "A Lost Lemon gold nugget souvenir"
                )
            }
        }
        .padding()
        .background(Color.black.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal)
    }
    
    private func rewardRow(icon: String, title: String, message: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.yellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
    }
}
