import SwiftUI

struct DotGridView: View {
    var horizontalDots = 18
    var dotSize: CGFloat = 2
    var horizontalMargin: CGFloat = 8
    var zoomScale: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let totalHeight = geometry.size.height
            let margin = horizontalMargin * zoomScale
            let scaledDotSize = dotSize * zoomScale

            let columns = horizontalDots
            let usableWidth = totalWidth - 2 * margin
            let spacing = usableWidth / CGFloat(max(columns - 1, 1))
            let startX = margin

            let rows = Int(ceil((totalHeight) / spacing))
            let startY = margin

            Path { path in
                for col in 0..<columns {
                    for row in 0..<rows {
                        let x = startX + CGFloat(col) * spacing
                        let y = startY + CGFloat(row) * spacing
                        path.addEllipse(in: CGRect(
                            x: x - scaledDotSize / 2,
                            y: y - scaledDotSize / 2,
                            width: scaledDotSize,
                            height: scaledDotSize
                        ))
                    }
                }
            }
            .fill(Theme.secondary.opacity(0.5))
        }
        .background(Theme.pageBackground)
    }
}
