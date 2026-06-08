//
//  ImageSceneView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

struct ImageSceneView: View {
    let imageName: String
    let canvasSize: CGSize
    let hotspots: [SceneHotspot]
    let showDebugHotspots: Bool
    let onHotspotTapped: (SceneHotspot) -> Void
    
    var body: some View {
        GeometryReader { geo in
            let layout = imageLayout(in: geo.size)
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: layout.renderedSize.width, height: layout.renderedSize.height)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    .clipped()
                
                ForEach(hotspots) { hotspot in
                    hotspotButton(
                        hotspot,
                        layout: layout
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func hotspotButton(
        _ hotspot: SceneHotspot,
        layout: ImageLayout
    ) -> some View {
        let scaledRect = scaleRect(hotspot.rect, layout: layout)
        
        return Button {
            onHotspotTapped(hotspot)
        } label: {
            Rectangle()
                .fill(showDebugHotspots ? Color.red.opacity(0.28) : Color.black.opacity(0.001))
                .contentShape(Rectangle())
                .overlay {
                    if showDebugHotspots {
                        Rectangle()
                            .stroke(Color.yellow, lineWidth: 2)
                        
                        Text(hotspot.name)
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
        }
        .buttonStyle(.plain)
        .frame(width: scaledRect.width, height: scaledRect.height)
        .position(x: scaledRect.midX, y: scaledRect.midY)
    }

    private func imageLayout(in containerSize: CGSize) -> ImageLayout {
        let scale = max(
            containerSize.width / canvasSize.width,
            containerSize.height / canvasSize.height
        )
        
        let renderedSize = CGSize(
            width: canvasSize.width * scale,
            height: canvasSize.height * scale
        )
        
        let origin = CGPoint(
            x: (containerSize.width - renderedSize.width) / 2,
            y: (containerSize.height - renderedSize.height) / 2
        )
        
        return ImageLayout(
            scale: scale,
            origin: origin,
            renderedSize: renderedSize
        )
    }
    
    private func scaleRect(_ rect: CGRect, layout: ImageLayout) -> CGRect {
        CGRect(
            x: layout.origin.x + rect.origin.x * layout.scale,
            y: layout.origin.y + rect.origin.y * layout.scale,
            width: rect.width * layout.scale,
            height: rect.height * layout.scale
        )
    }
}

struct ImageLayout {
    let scale: CGFloat
    let origin: CGPoint
    let renderedSize: CGSize
}

#Preview {
    ImageSceneView(
        imageName: "museum_exterior",
        canvasSize: CGSize(width: 1290, height: 2796),
        hotspots: [
            SceneHotspot(
                id: "mailbox",
                name: "Mailbox",
                rect: CGRect(x: 219, y: 1785, width: 268, height: 323)
            )
        ],
        showDebugHotspots: false,
        onHotspotTapped: { _ in }
    )
}
