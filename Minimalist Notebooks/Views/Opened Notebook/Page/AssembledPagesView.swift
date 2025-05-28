import SwiftUI
import Zoomable
import PencilKit

struct AssembledPagesView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    let notebook: Notebook
    @ObservedObject var toolbarVM: ToolbarVM     // holds selectedTool, etc.
    @ObservedObject var zoomController = NotebookZoomController()
    
    @State private var baseZoom: CGFloat = 1
    
    @State private var pageChangeTick = 0
    
    var body: some View {
        GeometryReader { frameSize in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ForEach(notebook.wrappedPages, id: \.self) { page in
                        let baseWidth = min(frameSize.size.width, frameSize.size.height * 0.75)
                        let baseHeight = min(frameSize.size.width * (4.0/3.0), frameSize.size.height)
                        
                        let zoomedWidth = baseWidth * zoomController.zoomScale
                        let zoomedHeight = baseHeight * zoomController.zoomScale

                        PageCanvasWrapperView(
                            pageModel: page,
                            selectedTool: $toolbarVM.activeTool,
                            zoomScale: $zoomController.zoomScale,
                            paperType: notebook.typeOfPaper
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.pageBackground)
                                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                        )
                        .padding(8 * zoomController.zoomScale)
                        .frame(width: zoomedWidth, height: zoomedHeight)
                    }
                    
                    AddPageView(onPress: {
                        notebook.addPage(context: context)
                        pageChangeTick += 1
                    })
                        .padding()
                }
                .id(pageChangeTick)
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

                        if zoomController.zoomScale == 1 {
                        // zoom in so that pageBaseW × zoomScale = containerW
                            zoomController.zoomScale = containerW / pageBaseW
                        } else {
                            zoomController.zoomScale = 1
                        }
                  }
            )
            .highPriorityGesture(
                MagnificationGesture()
                  .onChanged { relativeScale in
                      // multiply the gesture’s relative scale by the last baseZoom
                      let scaled = baseZoom * relativeScale
                      // clamp it between 1× and 5×
                      zoomController.zoomScale = min(max(scaled, 1), 5)
                  }
                  .onEnded { _ in
                      // commit the final zoom back into baseZoom
                      baseZoom = zoomController.zoomScale
                  }
            )
            .onAppear {
                // initialize baseZoom from whatever the VM has
                baseZoom = zoomController.zoomScale
            }
        }
    }
}
