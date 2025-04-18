import SwiftUI
import PencilKit
import Zoomable
import CloudKit

struct OpenedNotebookView: View {
    let notebookTitle: String
    let pageID: UUID  // Unique identifier for each page
    let onClose: () -> Void
    @State private var previousSize: CGSize = .zero // Track previous size

    @ObservedObject private var pageViewModel: AssembledPagesVM
    @ObservedObject private var toolbarViewModel: ToolbarVM

    // Custom initializer to pass pageID correctly
    init(notebookTitle: String, pageID: UUID, onClose: @escaping () -> Void) {
        self.notebookTitle = notebookTitle
        self.pageID = pageID
        self.onClose = onClose
        self.pageViewModel = AssembledPagesVM(pageID: pageID)
        self.toolbarViewModel = ToolbarVM()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        // Background canvas view with zoom/pan
                        PageCanvasView(
                            drawing: $pageViewModel.drawing,
                            selectedTool: $toolbarViewModel.activeTool,
                            dotsHorizontally: 27
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .aspectRatio(3/4, contentMode: .fit)
                        
                        .onDisappear() {
                            pageViewModel.saveDrawing()
                        }
                        .padding(8)
                        .pannableZoomable(minZoomScale: 1, maxZoomScale: 5, doubleTapZoomScale: 3, frameSize: pageViewModel.pageFrameSize)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - toolbarViewModel.toolbarHeight)
                    .overlay(content: {
                        GeometryReader { frameProxy in
                            Color.clear
                                .onAppear {
                                    previousSize = frameProxy.size
                                    pageViewModel.pageFrameSize = frameProxy.size
                                    print(frameProxy.size)
                                }
                                .onChange(of: frameProxy.size) { newSize in
                                    pageViewModel.rescaleDrawing(from: previousSize, to: frameProxy.size)
                                    pageViewModel.pageFrameSize = newSize
                                    previousSize = newSize
                                }
                        }
                    })
                }
                
                // ⬆️ Overlaid UI stays in place
                VStack {
                    ToolbarView(onClose: onClose, notebookTitle: notebookTitle, toolbarViewModel: toolbarViewModel)
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
            .onAppear(perform: {
                pageViewModel.pageFrameSize = geometry.size
            })
        }
    }
}
