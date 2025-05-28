import Foundation
import CoreData
import PencilKit

extension Notebook {
    var wrappedPages: [NotebookPage] {
        (pages as? Set<NotebookPage>)?.sorted(by: { $0.pageNumberIndex < $1.pageNumberIndex }) ?? []
    }

    var pageModels: [PageModel] {
        wrappedPages.map { $0.page }
    }
    
    var typeOfPaper: PaperType {
        get {
            PaperType(rawValue: self.paperType ?? "") ?? .blank  // default fallback
        }
        set {
            self.paperType = newValue.rawValue
        }
    }

    
    
    func addPage(context: NSManagedObjectContext) {
        let newPage = NotebookPage(context: context)
        newPage.id = UUID()
        newPage.pageNumberIndex = Int16(wrappedPages.count)
        newPage.drawing = PKDrawing().dataRepresentation()
        self.addToPages(newPage)

        do {
            try context.save()
        } catch {
            print("❌ Failed to save new page: \(error)")
        }
    }
}
