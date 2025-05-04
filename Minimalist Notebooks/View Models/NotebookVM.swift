import SwiftUI
import PencilKit

class NotebookVM: ObservableObject {
    @Published var notebook: Notebook
    @Published var zoomScale: CGFloat = 1.0
    
    init(notebook: Notebook) {
        self.notebook = notebook
    }
    
    func addPage() {
        notebook.pages.append(PageModel(pageNumberIndex: notebook.pages.count, drawing: PKDrawing()))
    }
}
