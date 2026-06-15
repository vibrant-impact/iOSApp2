//
//  HotspotZoomOverlay.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-11.
//

import SwiftUI

struct HotspotZoomOverlay: View {
    let title: String
    let imageName: String
    let description: String
    let primaryButtonTitle: String
    let onPrimaryAction: () -> Void
    let onClose: () -> Void
    
    private var shouldShowSecondaryCloseButton: Bool {
        primaryButtonTitle
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() != "close"
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title2.bold())
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Button(primaryButtonTitle) {
                    onPrimaryAction()
                }
                .buttonStyle(.borderedProminent)
                
                if shouldShowSecondaryCloseButton {
                    Button {
                        onClose()
                    } label: {
                        Text("Close")
                            .frame(width: 60)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding()
        }
    }
}
