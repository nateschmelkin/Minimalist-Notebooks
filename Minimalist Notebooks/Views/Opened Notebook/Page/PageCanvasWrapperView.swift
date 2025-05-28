import SwiftUI
import PencilKit

struct PageCanvasWrapperView: View {
    let pageModel: NotebookPage
    @Binding var selectedTool: PKTool
    @Binding var zoomScale: CGFloat
    var paperType: PaperType = .blank

    var body: some View {
        ZStack {
            paperBackground
            PageCanvasView(
                pageModel: pageModel,
                selectedTool: $selectedTool,
                zoomScale: $zoomScale,
                paperType: paperType
            )
        }
    }

    @ViewBuilder
    var paperBackground: some View {
        switch paperType {
        case .blank:
            Theme.pageBackground
        case .dots:
            DotGridView(zoomScale: zoomScale)
        case .lines:
            LinedPaperView(zoomScale: zoomScale)
        }
    }
}
