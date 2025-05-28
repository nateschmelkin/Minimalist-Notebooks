import Foundation
import CoreData
import PencilKit

class NotebookManager: ObservableObject {
    
    @Published var isShowingCreateNewNotebookView: Bool = false
    @Published var showNoNotebookNameWarning: Bool = false
    
    @Published var notebooks: [Notebook] = []
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        loadNotebooks()
    }

    func loadNotebooks() {
        let request = Notebook.fetchRequest()
        notebooks = (try? context.fetch(request)) ?? []
    }
    
    func createNotebook(title: String, paperType: PaperType){
        guard title != "" else {
            showNoNotebookNameWarning = true
            return
        }
        
        let newNotebook = Notebook(context: context)
        newNotebook.id = UUID()
        newNotebook.title = title
        newNotebook.activePageIndex = 0
        newNotebook.typeOfPaper = paperType
        
        // Optional: add a blank page
        let firstPage = NotebookPage(context: context)
        firstPage.id = UUID()
        firstPage.pageNumberIndex = 0
        firstPage.drawing = PKDrawing().dataRepresentation()
        
        newNotebook.addToPages(firstPage)

        do {
            try context.save()
        } catch {
            print("❌ Failed to save notebook: \(error)")
        }

        notebooks.append(newNotebook)
        loadNotebooks()
        showNoNotebookNameWarning = false
        isShowingCreateNewNotebookView = false
    }
    
    func addNotebook() {
        isShowingCreateNewNotebookView = true
    }
    
    func deleteNotebook(_ notebook: Notebook) {
        context.delete(notebook)

        do {
            try context.save()
            loadNotebooks() // Refresh list after deletion
        } catch {
            print("❌ Failed to delete notebook: \(error)")
        }
    }
}
