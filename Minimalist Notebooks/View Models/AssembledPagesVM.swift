import SwiftUI
import PencilKit

class AssembledPagesVM: ObservableObject {
    
    //Drawing
    @Published var drawing = PKDrawing() {
        didSet {
            print("📌 ViewModel updated, new stroke count: \(drawing.strokes.count)")
        }
    }
    
    @Published var zoomScale: CGFloat = 1.0
    @Published var zoomAnchor: UnitPoint = .center
    @Published var pageFrameSize: CGSize = .zero
    
    private let fileURL: URL
    
    init(pageID: UUID) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent("page_\(pageID).drawing")
        
        print("🆕 NotebookPageViewModel initialized for page \(pageID)")
        
        loadDrawing()
    }
    
    //RESCALE DRAWING && ZOOMING

    func rescaleDrawing(from oldSize: CGSize, to newSize: CGSize) {
        guard oldSize != .zero, newSize != .zero else { return }
        
        let scale = newSize.height / oldSize.height
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)


        // Apply the transformation to the entire drawing
        self.drawing = self.drawing.transformed(using: transform)
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
