import SwiftUI
import PencilKit
import Zoomable

struct IndividualPageView: View {
    @Binding var selectedInkingTool: PKTool

    @ObservedObject private var pageViewModel: AssembledPagesVM
    
    var body: some View {
        // Background canvas view with zoom/pan
        PageCanvasView(
            drawing: $pageViewModel.drawing,
            selectedTool: $selectedInkingTool,
            dotsHorizontally: 27
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .aspectRatio(3/4, contentMode: .fit)
        
        .onDisappear() {
            pageViewModel.saveDrawing()
        }
        .padding(8)
    }
}
