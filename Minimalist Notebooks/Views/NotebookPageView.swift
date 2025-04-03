import SwiftUI
import PencilKit

struct NotebookPageView: View {
    let notebookTitle: String
    let pageID: UUID  // Unique identifier for each page
    let onClose: () -> Void
    @State private var canvas = PKCanvasView()
    @State private var previousSize: CGSize = .zero // Track previous size

    @ObservedObject private var viewModel: NotebookPageViewModel

    // Custom initializer to pass pageID correctly
    init(notebookTitle: String, pageID: UUID, onClose: @escaping () -> Void) {
        self.notebookTitle = notebookTitle
        self.pageID = pageID
        self.onClose = onClose
        self.viewModel = NotebookPageViewModel(pageID: pageID)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                
                Text(notebookTitle)
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            
            // Toolbar
            HStack {
                Button(action: {
                    viewModel.selectPen()
                    canvas.tool = viewModel.selectedTool
                }) {
                    Image(systemName: "pencil.tip")
                        .font(.title)
                }
                .padding()
                
                Button(action: {
                    viewModel.selectEraser()
                    canvas.tool = viewModel.selectedTool
                }) {
                    Image(systemName: "eraser")
                        .font(.title)
                }
                .padding()
                
                Spacer()
            }
            .background(Color.gray)
            
            GeometryReader { geometry in
                ZStack {
                    
                    PageCanvasView(drawing: $viewModel.drawing, selectedTool: $viewModel.selectedTool)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .aspectRatio(4/5, contentMode: .fit)
                        .onAppear() {
                            previousSize = geometry.size
                        }
                        .onChange(of: geometry.size) { newSize in
                            viewModel.rescaleDrawing(from: previousSize, to: newSize)
                            previousSize = newSize
                        }
                    //TODO WORK HERE TO FIX ZOOMING AND PANNING
                        .scaleEffect(viewModel.zoomScale)  // Zoom in/out effect
                        .offset(viewModel.offset)  // Pan effect
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let newScale = max(1.0, min(value, 3.0)) // Keep zoom between 1x and 3x
                                    if newScale != viewModel.zoomScale {
                                        viewModel.zoomScale = newScale
                                        viewModel.offset = viewModel.clampOffset(viewModel.offset, for: geometry.size, in: geometry.size)
                                    }
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = CGSize(
                                        width: value.translation.width + viewModel.lastOffset.width,
                                        height: value.translation.height + viewModel.lastOffset.height
                                    )
                                    viewModel.offset = viewModel.clampOffset(newOffset, for: geometry.size, in: geometry.size)
                                }
                                .onEnded { _ in
                                    viewModel.lastOffset = viewModel.offset // Store final position for the next drag
                                }
                        )

                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                
                Spacer()
            }
            .onDisappear() {
                viewModel.saveDrawing()
            }
            .padding()
        }
    }
}
