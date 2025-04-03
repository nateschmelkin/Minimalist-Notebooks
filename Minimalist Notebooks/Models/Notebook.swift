import Foundation

struct Notebook: Identifiable, Codable {
    let id: UUID  // Immutable once initialized
    var title: String
    var pages: [PageModel]

    // Custom initializer ensures id is set once
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
        self.pages = [PageModel(pageNumber: 1)]  // Start with one default page
    }

    mutating func addPage() {
        pages.append(PageModel(pageNumber: pages.count+1))  // Add new page
    }
}
