import UIKit

extension UIImage {
    /// Generates a dot pattern image to be used as a repeating pattern.
    /// The tile’s width is computed so that exactly `dotsHorizontally` dot centers fit
    /// in the given containerWidth, then adjusted to be pixel‑aligned.
    ///
    /// - Parameters:
    ///   - containerWidth: The width (in points) in which the dots will be laid out.
    ///   - dotsHorizontally: The number of dot centers you want to fit across that width.
    ///   - dotSize: The diameter of each dot, in points.
    ///   - dotColor: The color of the dots.
    ///   - backgroundColor: The background color (e.g. a yellowish hue).
    /// - Returns: A pattern image that repeats the dot tile.
    static func dotPaperImage(
        containerWidth: CGFloat,
        dotsHorizontally: Int = 20,
        dotSize: CGFloat = 2,
        dotColor: UIColor = UIColor.gray.withAlphaComponent(0.3),
        backgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
    ) -> UIImage? {
        // Validate input.
        guard containerWidth > 0, dotsHorizontally > 0 else {
            return nil
        }
        
        // Get device scale.
        let scale = UIScreen.main.scale
        
        // Compute the raw spacing in points.
        let rawSpacing = containerWidth / CGFloat(dotsHorizontally)
        // Round the spacing to pixel boundaries.
        let spacing = CGFloat(round(Double(rawSpacing * scale))) / scale
        
        let tileSize = CGSize(width: spacing, height: spacing)
        guard tileSize.width > 0, tileSize.height > 0 else { return nil }
        
        // Set up the image renderer with our computed scale.
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = scale
        let renderer = UIGraphicsImageRenderer(size: tileSize, format: rendererFormat)
        
        let image = renderer.image { context in
            let ctx = context.cgContext
            // Disable interpolation to avoid unexpected blurring at tile boundaries.
            ctx.interpolationQuality = .none
            
            // Fill the entire tile with the paper background color.
            ctx.setFillColor(backgroundColor.cgColor)
            ctx.fill(CGRect(origin: .zero, size: tileSize))
            
            // Draw the dot centered in the tile.
            ctx.setFillColor(dotColor.cgColor)
            let dotRect = CGRect(
                x: (spacing - dotSize) / 2,
                y: (spacing - dotSize) / 2,
                width: dotSize,
                height: dotSize
            )
            ctx.fillEllipse(in: dotRect)
        }
        return image
    }
}
