import SwiftUI
import PencilKit

struct PageCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var selectedTool: PKTool
    var dotsHorizontally: Int = 20
  
    @State private var effectiveWidth: CGFloat = 0  // Measured effective width
  
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawing = drawing
        canvas.drawingPolicy = .pencilOnly
        // Set an initial background; it will be updated in updateUIView based on effectiveWidth.
        canvas.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
        canvas.overrideUserInterfaceStyle = .light
        canvas.becomeFirstResponder()
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update drawing or tool as needed.
        if uiView.drawing != drawing { uiView.drawing = drawing }
        uiView.tool = selectedTool
        print(uiView.tool)
        
        // Use the actual width of the uiView bounds, which respects the aspect ratio and padding.
        let currentEffectiveWidth = uiView.bounds.width
        DispatchQueue.main.async {  // update on main thread
            self.effectiveWidth = currentEffectiveWidth
        }
        
        if let dotImage = UIImage.dotPaperImage(
            containerWidth: currentEffectiveWidth,
            dotsHorizontally: dotsHorizontally,
            dotSize: 1.5,
            dotColor: UIColor.gray.withAlphaComponent(0.3),
            backgroundColor: UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
        ) {
            uiView.backgroundColor = UIColor(patternImage: dotImage)
        } else {
            uiView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PageCanvasView
        init(_ parent: PageCanvasView) { self.parent = parent }
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async { self.parent.drawing = canvasView.drawing }
        }
    }
}
