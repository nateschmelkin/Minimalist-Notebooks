import SwiftUI
import PencilKit

class CoverGridVM: ObservableObject {
    
    @Published var isShowingCreateNewNotebookView: Bool = false
    @Published var showNoNotebookNameWarning: Bool = false
    @Published var notebooks: [Notebook] = []
    @Published var selectedNotebook: Notebook?
    
    func addNotebook(notebookTitle: String) {
        guard notebookTitle != "" else {
            showNoNotebookNameWarning = true
            return
        }
        // Create a new notebook with an initial page
        let newNotebook = Notebook(title: notebookTitle, pages: [PageModel(pageNumberIndex: 0, drawing: PKDrawing())])
        notebooks.append(newNotebook)
        showNoNotebookNameWarning = false
        isShowingCreateNewNotebookView = false
    }
    
    func createNewNotebook() {
        isShowingCreateNewNotebookView = true
    }
}
