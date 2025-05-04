import Foundation
import PencilKit

struct PageModel: Identifiable{
    var id = UUID()
    var pageNumberIndex: Int
    var drawing: PKDrawing
}
