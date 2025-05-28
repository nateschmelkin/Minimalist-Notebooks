import SwiftUI

struct ToolbarView: View {
    let onClose: () -> Void
    let notebookTitle: String
    
    @ObservedObject var toolbarViewModel: ToolbarVM
    
    @State private var showingColorPicker = false
    @State private var showingWidthSlider = false
    
    private var tools: [ToolConfig] {
        ToolbarToolFactory.makeConfigs(
            from: toolbarViewModel
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            bottomToolbar
            Divider()
                .foregroundStyle(Theme.divider)
        }
        .onAppear() {
            toolbarViewModel.setActivePen(pen: toolbarViewModel.penPresets[0])
        }
        .overlay(
            GeometryReader { toolbarGeo in
                // Capture the toolbar height inside this reader
                Color.clear
                    .onAppear {
                        toolbarViewModel.toolbarHeight = toolbarGeo.size.height
                    }
                    .frame(width: 0, height: 0)
            }
        )
    }
    
    private var topBar: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(Theme.textPrimary)
            }
            
            Text(notebookTitle)
                .font(.title)
                .foregroundStyle(Theme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Theme.topBarBackground)
    }
    
    private var bottomToolbar: some View {
        HStack {
            ForEach(tools) { config in
                if config.type == .spacer {
                    Spacer(minLength: 12)
                } else {
                    ToolbarToolButton(
                        config: config,
                        onTap: {
                            ToolActionRouter.handleTap(config.type, vm: toolbarViewModel, showColorPicker: &showingColorPicker, showWidthSlider: &showingWidthSlider)
                        },
                        onDelete: {
                            ToolActionRouter.handleDelete(config.type, vm: toolbarViewModel)
                        }
                    )
                }
            }
        }
        .padding(4)
        .background(Theme.bottomBarBackground)
        .popover(isPresented: $showingColorPicker) {
            PenColorPicker(toolbarVM: toolbarViewModel)
        }
        .popover(isPresented: $showingWidthSlider) {
            PenWidthPicker(toolbarVM: toolbarViewModel)
        }
    }
}
