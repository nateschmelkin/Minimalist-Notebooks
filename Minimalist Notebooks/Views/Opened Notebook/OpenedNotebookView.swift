import SwiftUI
import PencilKit
import Zoomable
import CloudKit

struct OpenedNotebookView: View {
    let notebookVM: NotebookVM
    let onClose: () -> Void
    

//    @ObservedObject private var pageViewModel: AssembledPagesVM
    @StateObject var toolbarViewModel = ToolbarVM()
    
    @State private var previousSize: CGSize = .zero // Track previous size
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    AssembledPagesView(notebookVM: notebookVM, toolbarVM: toolbarViewModel)
                        .frame(width: geometry.size.width, height: geometry.size.height - toolbarViewModel.toolbarHeight)
                }
                
                // ⬆️ Overlaid UI stays in place
                VStack {
                    ToolbarView(onClose: onClose, notebookTitle: notebookVM.notebook.title, toolbarViewModel: toolbarViewModel)
                        .popover(isPresented: $toolbarViewModel.isShowingPenSettings) {
                            PenEditorView(activeToolSettings: toolbarViewModel.activeToolSettings)
                                .onDisappear {
                                    toolbarViewModel.setActivePenTool(settings: toolbarViewModel.activeToolSettings)
                                }
                        }
                    Spacer()
                }
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
    }
}
