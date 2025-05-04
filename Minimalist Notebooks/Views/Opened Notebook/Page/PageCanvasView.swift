import SwiftUI
import PencilKit

struct PageCanvasView: UIViewRepresentable {
    @StateObject var pageVM: IndividualPageVM
    @Binding var selectedTool: PKTool
    @Binding var zoomScale: CGFloat
    
    var dotsHorizontally: Int = 20
  
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawing = pageVM.page.drawing
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
        
        canvas.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
        
        canvas.overrideUserInterfaceStyle = .light
        canvas.becomeFirstResponder()
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing.dataRepresentation() != pageVM.page.drawing.dataRepresentation(){
          uiView.drawing = pageVM.page.drawing
        }
        
        uiView.tool = selectedTool
        
        uiView.setZoomScale(zoomScale, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PageCanvasView
        init(_ parent: PageCanvasView) { self.parent = parent }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async { self.parent.pageVM.page.drawing = canvasView.drawing }
        }
    }
}
