//
//  JournalView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-13.
//

import SwiftUI

struct JournalView: View {
    
    @EnvironmentObject private var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            HStack {
            
                Button {
                    SoundManager.shared.play(.close, volume: 0.45)
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding()
                
    
                Text("Journal")
                    .font(.title.bold())
                    .foregroundStyle(.white)
           
                Spacer()
            }
            
            
            progressCard
            
            List {
                if gameState.journalPhotos.isEmpty {
                    emptyJournalView
                } else {
                    journalRows
                }
            }
        }
    }
    
    // MARK: - Progress Card
    
    /// Shows the player's photo scavenger hunt progress.
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Historical photos captured:")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Large visual count of collected photos.
                Text("\(gameState.photoCount) / \(gameState.totalPhotoCount)")
                    .font(.largeTitle.bold())
            }
            
            Divider()
            
            Text("Capture at least 5 photos to unlock bonuses.")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            Text("Find all 9 and solve the curator's puzzle to")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            Text("unlock the $5000 grand prize draw entry.")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                
                Text("Discount Code:")
                    .font(.subheadline.bold())
                
                Spacer()
                
                // Shows either a reward code or "LOCKED".
                //
                // If the reward is still locked, the text is gray.
                // If a reward code has been earned, the text turns green.
                Text(gameState.photoRewardCode)
                    .font(.title3.bold())
                    .foregroundColor(gameState.photoRewardCode == "LOCKED" ? Color.secondary : Color.green)
            }
        }
        .padding()
    }
    
    // MARK: - Empty State
    
    private var emptyJournalView: some View {
        VStack(spacing: 12) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            
            Text("No Journal Photos Yet")
                .font(.headline)
            
            Text("Take photos of important Banff history hotspots to collect notes and hidden letters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Mini Pics
    private func miniPolaroid(for photo: Photo) -> some View {
        let rotation = rotationForPhoto(photo)
        
        return VStack(spacing: 4) {
            Image(photo.cameraImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            Text(photo.secretLetter)
                .font(.caption.bold())
                .foregroundStyle(.red)
        }
        .padding(6)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 2)
        .rotationEffect(.degrees(rotation))
    }
    
    private func rotationForPhoto(_ photo: Photo) -> Double {
        switch photo.id {
        case Photo.museumExterior.id: return -2
        case Photo.bowFalls.id: return 1.5
        case Photo.caveAndBasin.id: return -1
        case Photo.banffSpringsHotel.id: return 2
        case Photo.downtownBanff.id: return -1.5
        case Photo.hotSprings.id: return 1
        case Photo.sulphurMountain.id: return -2
        case Photo.lakeMinnewanka.id: return 1.8
        case Photo.tunnelMountain.id: return -0.8
        default: return 0
        }
    }
    
    // MARK: - Rows
    
    private var journalRows: some View {
        ForEach(gameState.journalPhotos) { photo in
            HStack(alignment: .top, spacing: 14) {
                miniPolaroid(for: photo)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        
                        Text(photo.photoName)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(photo.secretLetter)
                            .font(.title3.bold())
                            .foregroundStyle(.orange)
                            .frame(width: 36, height: 36)
                            .background(.orange.opacity(0.15))
                            .clipShape(Circle())
                    }
                    
                    Text(photo.historicalNote)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Preview

#Preview {
    JournalView()
        .environmentObject(GameState())
}
