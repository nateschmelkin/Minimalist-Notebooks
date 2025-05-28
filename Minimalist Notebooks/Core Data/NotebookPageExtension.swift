import CoreData
import PencilKit
import SwiftUI
import UIKit

extension NotebookPage {
    var page: PageModel {
        PageModel(
            pageNumberIndex: Int(pageNumberIndex),
            drawing: (try? PKDrawing(data: drawing ?? Data())) ?? PKDrawing()
        )
    }
}
