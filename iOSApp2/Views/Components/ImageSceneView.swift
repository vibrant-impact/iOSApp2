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
    let overlayObjects: [SceneOverlayObject]
    let showDebugHotspots: Bool
    let onHotspotTapped: (SceneHotspot) -> Void
    
    
    // MARK: - Init
    
    init(
        imageName: String,
        canvasSize: CGSize,
        hotspots: [SceneHotspot],
        overlayObjects: [SceneOverlayObject] = [],
        showDebugHotspots: Bool,
        onHotspotTapped: @escaping (SceneHotspot) -> Void
    ) {
        self.imageName = imageName
        self.canvasSize = canvasSize
        self.hotspots = hotspots
        self.overlayObjects = overlayObjects
        self.showDebugHotspots = showDebugHotspots
        self.onHotspotTapped = onHotspotTapped
    }
    
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            let layout = imageLayout(in: geo.size)
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Base scene image.
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: layout.renderedSize.width,
                        height: layout.renderedSize.height
                    )
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    .clipped()
                
                // Visual state overlays, such as opened mailboxes or removed items.
                ForEach(overlayObjects) { overlayObject in
                    overlayImage(
                        overlayObject,
                        layout: layout
                    )
                }
                
                // Invisible tappable hotspot areas.
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
    
    
    // MARK: - Overlay Images
    
    private func overlayImage(
        _ overlayObject: SceneOverlayObject,
        layout: ImageLayout
    ) -> some View {
        let scaledRect = scaleRect(overlayObject.rect, layout: layout)
        
        return Image(overlayObject.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: scaledRect.width, height: scaledRect.height)
            .position(x: scaledRect.midX, y: scaledRect.midY)
            .allowsHitTesting(false)
    }
    
    // MARK: - Hotspot Button
    
    private func hotspotButton(
        _ hotspot: SceneHotspot,
        layout: ImageLayout
    ) -> some View {
        let scaledRect = scaleRect(hotspot.rect, layout: layout)
        
        return Button {
            onHotspotTapped(hotspot)
        } label: {
            Rectangle()
                .fill(
                    showDebugHotspots
                    ? Color.red.opacity(0.28)
                    : Color.black.opacity(0.001)
                )
                .contentShape(Rectangle())
                .overlay {
                    if showDebugHotspots {
                        Rectangle()
                            .stroke(Color.yellow, lineWidth: 2)
                        
                        Text(hotspot.name)
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(.black.opacity(0.65))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
        }
        .buttonStyle(.plain)
        .frame(width: scaledRect.width, height: scaledRect.height)
        .position(x: scaledRect.midX, y: scaledRect.midY)
    }
    
    
    // MARK: - Layout Calculation
    
    /// Matches SwiftUI's `.scaledToFill()` behavior for the base image.
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
        
    // MARK: - Coordinate Scaling
    
    /// Converts original canvas coordinates into current screen coordinates.
    private func scaleRect(_ rect: CGRect, layout: ImageLayout) -> CGRect {
        CGRect(
            x: layout.origin.x + rect.origin.x * layout.scale,
            y: layout.origin.y + rect.origin.y * layout.scale,
            width: rect.width * layout.scale,
            height: rect.height * layout.scale
        )
    }
}

// MARK: - Image Layout Model

struct ImageLayout {
    let scale: CGFloat
    let origin: CGPoint
    let renderedSize: CGSize
}

// MARK: - Preview

#Preview {
    ImageSceneView(
        imageName: "museum_exterior_base",
        canvasSize: CGSize(width: 1290, height: 2796),
        hotspots: [
            SceneHotspot(
                id: "mailbox",
                name: "Mailbox",
                rect: CGRect(x: 13, y: 1871, width: 354, height: 245)
            ),
            SceneHotspot(
                id: "shovel",
                name: "Small Shovel",
                rect: CGRect(x: 992, y: 2291, width: 197, height: 266)
            )
        ],
        overlayObjects: [
            SceneOverlayObject(
                id: "mailbox_open",
                imageName: "museum_mailbox_open_overlay",
                rect: CGRect(x: 187, y: 1909, width: 253, height: 312)
            )
        ],
        showDebugHotspots: true,
        onHotspotTapped: { hotspot in
            print("Tapped hotspot: \(hotspot.name)")
        }
    )
}
