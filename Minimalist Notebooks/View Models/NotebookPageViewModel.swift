import SwiftUI
import PencilKit

class NotebookPageViewModel: ObservableObject {
    @Published var drawing = PKDrawing() {
        didSet {
            print("📌 ViewModel updated, new stroke count: \(drawing.strokes.count)")
        }
    }
    
    @Published var selectedTool: PKTool = PKInkingTool(.pen, color: UIColor(.black), width: 4)
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    
    var lastOffset: CGSize = .zero  // Tracks last position after drag ends
    
    private let fileURL: URL
    
    init(pageID: UUID) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent("page_\(pageID).drawing")
        
        print("🆕 NotebookPageViewModel initialized for page \(pageID)")
        
        loadDrawing()
    }

    // TOOL SELECT
    func selectPen() {
        selectedTool = PKInkingTool(.pen, color: UIColor(.black), width: 4)
    }
    
    func selectEraser() {
        selectedTool = PKEraserTool(.bitmap, width: 100)
    }
    
    //RESCALE DRAWING && ZOOMING

    func rescaleDrawing(from oldSize: CGSize, to newSize: CGSize) {
        guard oldSize != .zero, newSize != .zero else { return }
        
        let scale = newSize.height / oldSize.height
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)


        // Apply the transformation to the entire drawing
        self.drawing = self.drawing.transformed(using: transform)
    }
    
    func clampOffset(_ proposedOffset: CGSize, for canvasSize: CGSize, in viewSize: CGSize) -> CGSize {
        guard zoomScale > 1.0 else { return .zero } // No panning if fully zoomed out

        let scaledWidth = canvasSize.width * zoomScale
        let scaledHeight = canvasSize.height * zoomScale

        let maxOffsetX = (scaledWidth - canvasSize.width) / 2
        let maxOffsetY = (scaledHeight - canvasSize.height) / 2

        let clampedX = max(-maxOffsetX, min(proposedOffset.width, maxOffsetX))
        let clampedY = max(-maxOffsetY, min(proposedOffset.height, maxOffsetY))

        return CGSize(width: clampedX, height: clampedY)
    }

    
    // DATA STORAGE AND SAVING
    func loadDrawing() {
        if let data = try? Data(contentsOf: fileURL),
           let loadedDrawing = try? PKDrawing(data: data) {
            self.drawing = loadedDrawing
            print("✅ Drawing loaded, stroke count: \(drawing.strokes.count)")
        } else {
            print("⚠️ No saved drawing file found at: \(fileURL.path)")
        }
    }

    func saveDrawing() {
        do {
            let data = drawing.dataRepresentation()
            try data.write(to: fileURL)
            print("✅ Drawing saved successfully at: \(fileURL.path)")
        } catch {
            print("❌ Failed to save drawing: \(error.localizedDescription)")
        }
    }
}
