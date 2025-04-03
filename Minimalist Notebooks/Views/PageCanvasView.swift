import SwiftUI
import PencilKit

struct PageCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing  // Bind the drawing data
    @Binding var selectedTool: PKTool // Bind tool
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawing = drawing
        
        canvas.drawingPolicy = .pencilOnly
        canvas.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.89, alpha: 1.0)
        
        canvas.overrideUserInterfaceStyle = .light
        canvas.becomeFirstResponder()
        canvas.delegate = context.coordinator // Track changes in drawing
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            print("🖊 UI update triggered. Current strokes: \(uiView.drawing.strokes.count), New strokes: \(drawing.strokes.count)")
            uiView.drawing = drawing
        }
        uiView.tool = selectedTool
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PageCanvasView
        
        init(_ parent: PageCanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.drawing = canvasView.drawing
            }
        }
    }
}
