import Foundation
import PencilKit

struct PageModel: Identifiable, Codable {
    let id: UUID
    var pageNumber: Int
    var drawingData: Data  // Store PKDrawing as Data

    // Computed property to get/set PKDrawing
    var drawing: PKDrawing {
        get {
            (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }
        set {
            drawingData = newValue.dataRepresentation()
        }
    }

    // Custom initializer to allow decoding while keeping UUID
    init(id: UUID = UUID(), pageNumber: Int, drawing: PKDrawing = PKDrawing()) {
        self.id = id
        self.pageNumber = pageNumber
        self.drawingData = drawing.dataRepresentation()
    }

    // Custom CodingKeys to match stored properties
    enum CodingKeys: String, CodingKey {
        case id, pageNumber, drawingData
    }
}
