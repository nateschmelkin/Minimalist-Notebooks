import SwiftUI
import PencilKit

struct PageCanvasView: UIViewRepresentable {
    let pageModel: NotebookPage
    @Binding var selectedTool: PKTool
    @Binding var zoomScale: CGFloat
    
    var paperType: PaperType = .blank
  
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawing = pageModel.page.drawing
        canvas.drawingPolicy = .pencilOnly
        
        canvas.minimumZoomScale = 1
        canvas.maximumZoomScale = 5
        
        canvas.isScrollEnabled = false
        canvas.bounces = false
        canvas.gestureRecognizers?
          .compactMap { $0 as? UIPinchGestureRecognizer }
          .forEach { pinch in
            // —or remove entirely—
             canvas.removeGestureRecognizer(pinch)
          }
        
        canvas.backgroundColor = UIColor.clear
        
        canvas.overrideUserInterfaceStyle = .light
        canvas.becomeFirstResponder()
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing.dataRepresentation() != pageModel.drawing{
            uiView.drawing = pageModel.page.drawing
        }
        
        uiView.tool = selectedTool
        uiView.setZoomScale(zoomScale, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PageCanvasView
        init(_ parent: PageCanvasView) { self.parent = parent }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async { self.parent.pageModel.drawing = canvasView.drawing.dataRepresentation() }
        }
    }
}
