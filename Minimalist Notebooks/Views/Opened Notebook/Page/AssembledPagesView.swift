import SwiftUI
import Zoomable
import PencilKit

struct AssembledPagesView: View {
    @ObservedObject var notebookVM: NotebookVM   // your VM that has [PageModel]
    @ObservedObject var toolbarVM: ToolbarVM     // holds selectedTool, etc.
    
    @State private var baseZoom: CGFloat = 1
    
    var body: some View {
        GeometryReader { frameSize in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ForEach(notebookVM.notebook.pages) { page in
                        PageCanvasView(
                            pageVM: IndividualPageVM(page: page),
                            selectedTool: $toolbarVM.activeTool,
                            zoomScale: $notebookVM.zoomScale,
                            dotsHorizontally: 27
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(8)
                        .frame(
                            width:  min(frameSize.size.width,
                                        frameSize.size.height * (3/4))
                                          * notebookVM.zoomScale,
                            height: min(frameSize.size.width * (4/3),
                                        frameSize.size.height)
                                          * notebookVM.zoomScale
                        )
                    }
                    
                    AddPageView(onPress: {notebookVM.addPage()})
                        .padding()
                }
                .frame(minWidth: frameSize.size.width)
            }
            .gesture(
                TapGesture(count: 2)
                    .onEnded {
                        let aspect: CGFloat = 3.0/4.0
                        let containerW = frameSize.size.width
                        let containerH = frameSize.size.height

                        // compute the width the page actually is at 1×
                        let pageBaseW = min(containerW, containerH * aspect)

                        if notebookVM.zoomScale == 1 {
                        // zoom in so that pageBaseW × zoomScale = containerW
                            notebookVM.zoomScale = containerW / pageBaseW
                        } else {
                            notebookVM.zoomScale = 1
                        }
                  }
            )
            .highPriorityGesture(
                MagnificationGesture()
                  .onChanged { relativeScale in
                      // multiply the gesture’s relative scale by the last baseZoom
                      let scaled = baseZoom * relativeScale
                      // clamp it between 1× and 5×
                      notebookVM.zoomScale = min(max(scaled, 1), 5)
                  }
                  .onEnded { _ in
                      // commit the final zoom back into baseZoom
                      baseZoom = notebookVM.zoomScale
                  }
            )
            .onAppear {
                // initialize baseZoom from whatever the VM has
                baseZoom = notebookVM.zoomScale
            }
        }
    }
}
