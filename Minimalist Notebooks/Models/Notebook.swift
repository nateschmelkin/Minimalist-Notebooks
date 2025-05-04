import Foundation
import PencilKit

struct Notebook: Identifiable {
    let id = UUID()
    let title: String
    var pages: [PageModel]
    var activePageIndex: Int = 0
}
