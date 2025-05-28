import SwiftUI
import PencilKit
import Zoomable
import CloudKit

struct OpenedNotebookView: View {
    let notebook: Notebook
    @ObservedObject private var notebookManager: NotebookManager
    let onClose: () -> Void

    @StateObject private var toolbarViewModel: ToolbarVM
    
    @State private var previousSize: CGSize = .zero // Track previous size
    
    init(notebook: Notebook, notebookManager: NotebookManager, onClose: @escaping () -> Void) {
        self.notebook = notebook
        self.notebookManager = notebookManager
        self.onClose = onClose
        _toolbarViewModel = StateObject(wrappedValue: ToolbarVM(context: PersistenceController.shared.container.viewContext))
    }

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    AssembledPagesView(notebook: notebook, toolbarVM: toolbarViewModel)
                        .frame(width: geometry.size.width, height: geometry.size.height - toolbarViewModel.toolbarHeight)
                }
                
                // ⬆️ Overlaid UI stays in place
                VStack {
                    ToolbarView(
                        onClose: onClose,
                        notebookTitle: notebook.title!,
                        toolbarViewModel: toolbarViewModel
                    )
                    Spacer()
                }
            }
            .background(Theme.appBackground)
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
    }
}
