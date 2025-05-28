import SwiftUI

struct LinedPaperView: View {
    var lineSpacing: CGFloat = 30
    var zoomScale: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let height = geometry.size.height
                let width = geometry.size.width

                var currentY: CGFloat = (lineSpacing + 0.5) * zoomScale
                while currentY < height {
                    path.move(to: CGPoint(x: 0, y: currentY))
                    path.addLine(to: CGPoint(x: width, y: currentY))
                    currentY += lineSpacing * zoomScale
                }
            }
            .stroke(Theme.secondary.opacity(0.3), lineWidth: 1 * zoomScale)
        }
        .background(Theme.pageBackground)
    }
}

