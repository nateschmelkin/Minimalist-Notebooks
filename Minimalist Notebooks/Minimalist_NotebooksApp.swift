import SwiftUI
import Foundation

@main
struct Minimalist_NotebooksApp: App {
    let persistenceController = PersistenceController.shared
    

    var body: some Scene {
        WindowGroup {
            CoverGridView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
