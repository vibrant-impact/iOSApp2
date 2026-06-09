//
//  ImageSceneView.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-07.
//

import SwiftUI

/// Displays a full-screen scene image with tappable hotspot rectangles.
///
/// `ImageSceneView` is used for image-based exploration scenes.
/// It shows one background image, then places invisible or debug-visible
/// buttons over specific areas of that image.
///
/// This allows the player to tap parts of the scene such as:
/// - a mailbox
/// - a museum door
/// - a sign
/// - a clue
/// - an object in the snow
///
/// The hotspot rectangles are defined in the coordinate system of the original
/// image canvas. This view scales those rectangles so they still line up with
/// the displayed image on different device sizes.
struct ImageSceneView: View {
    
    /// The asset catalog name of the scene image to display.
    ///
    /// Example:
    /// `"museum_exterior"`
    let imageName: String
    
    /// The original design size of the image canvas.
    ///
    /// Hotspot rectangles are positioned using this coordinate system.
    ///
    /// Example:
    /// If the original image is `1290 x 2796`, then a hotspot at
    /// `x: 219, y: 1785` is interpreted relative to that original canvas size.
    let canvasSize: CGSize
    
    /// The tappable areas that should be placed over the scene image.
    let hotspots: [SceneHotspot]
    
    /// Controls whether hotspot rectangles are visible for debugging.
    ///
    /// When `true`, hotspots appear as red translucent rectangles with yellow
    /// outlines and labels.
    ///
    /// When `false`, hotspots are almost invisible but still tappable.
    let showDebugHotspots: Bool
    
    /// A closure that runs when the player taps a hotspot.
    ///
    /// The parent scene decides what should happen after a hotspot is tapped.
    let onHotspotTapped: (SceneHotspot) -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            
            // Calculates how the original image canvas should be scaled and
            // positioned inside the current device screen.
            let layout = imageLayout(in: geo.size)
            
            ZStack {
                
                // Black background fills any uncovered space.
                Color.black.ignoresSafeArea()
                
                // MARK: Scene Image
                
                // Displays the background image.
                //
                // The image is scaled to fill the available screen, matching the
                // same layout calculations used for hotspot positioning.
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
                
                // MARK: Hotspot Overlays
                
                // Places one tappable button over each scene hotspot.
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
    
    
    // MARK: - Hotspot Button
    
    /// Creates the tappable overlay for a single hotspot.
    ///
    /// The hotspot's original rectangle is scaled into screen coordinates using
    /// the current `ImageLayout`.
    ///
    /// - Parameters:
    ///   - hotspot: The scene hotspot to display.
    ///   - layout: The current scaled image layout.
    /// - Returns: A tappable overlay view positioned over the correct image area.
    private func hotspotButton(
        _ hotspot: SceneHotspot,
        layout: ImageLayout
    ) -> some View {
        
        // Converts the hotspot from original canvas coordinates into the
        // currently rendered screen coordinates.
        let scaledRect = scaleRect(hotspot.rect, layout: layout)
        
        return Button {
            
            // Tell the parent view which hotspot was tapped.
            onHotspotTapped(hotspot)
            
        } label: {
            Rectangle()
            
                // In debug mode, show the hotspot area in red.
                //
                // Outside debug mode, use a nearly invisible fill.
                // A tiny opacity keeps the rectangle tappable while making it
                // visually hidden.
                .fill(showDebugHotspots ? Color.red.opacity(0.28) : Color.black.opacity(0.001))
                
                // Ensures the full rectangle area is tappable.
                .contentShape(Rectangle())
                .overlay {
                    
                    // Optional debug outline and label.
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
        
        // Removes the default button styling so the rectangle overlay does not
        // get highlighted like a standard SwiftUI button.
        .buttonStyle(.plain)
        
        // Sizes the overlay to match the scaled hotspot rectangle.
        .frame(width: scaledRect.width, height: scaledRect.height)
        
        // Places the overlay at the center point of the scaled hotspot rectangle.
        .position(x: scaledRect.midX, y: scaledRect.midY)
    }
    
    
    // MARK: - Image Layout Calculation

    /// Calculates how the original image canvas is rendered inside the container.
    ///
    /// This uses a `scaledToFill` style calculation:
    /// - the image is scaled until it fully covers the container
    /// - some image content may extend beyond the visible screen
    /// - the image is centered in the available space
    ///
    /// The returned layout is also used to scale hotspot rectangles so they stay
    /// aligned with the image.
    ///
    /// - Parameter containerSize: The size of the available screen or parent view.
    /// - Returns: An `ImageLayout` containing scale, origin, and rendered size.
    private func imageLayout(in containerSize: CGSize) -> ImageLayout {
        
        // Use the larger scale value so the image fills the entire container.
        //
        // This matches `.scaledToFill()`.
        let scale = max(
            containerSize.width / canvasSize.width,
            containerSize.height / canvasSize.height
        )
        
        // The final size of the image after scaling.
        let renderedSize = CGSize(
            width: canvasSize.width * scale,
            height: canvasSize.height * scale
        )
        
        // The top-left corner of the rendered image.
        //
        // This may be negative if the scaled image is larger than the screen,
        // which happens with scaled-to-fill cropping.
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
    
    
    // MARK: - Hotspot Scaling
    
    /// Converts a hotspot rectangle from original image coordinates to screen coordinates.
    ///
    /// The original hotspot rectangle is based on `canvasSize`.
    /// This function applies the same scale and offset used by the rendered image.
    ///
    /// - Parameters:
    ///   - rect: The hotspot rectangle in original canvas coordinates.
    ///   - layout: The current image layout.
    /// - Returns: The hotspot rectangle in screen coordinates.
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

/// Stores layout information for a rendered scene image.
///
/// This helps keep the image and its hotspots aligned after scaling.
struct ImageLayout {
    
    /// The scale factor applied to the original image canvas.
    let scale: CGFloat
    
    /// The top-left position of the rendered image inside the container.
    let origin: CGPoint
    
    /// The final displayed size of the image after scaling.
    let renderedSize: CGSize
}


// MARK: - Preview

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
