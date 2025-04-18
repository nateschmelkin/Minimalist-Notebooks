//
//  Toolbar.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 4/11/25.
//

import SwiftUI

struct ToolbarView: View {
    let onClose: () -> Void
    let notebookTitle: String
    
    @ObservedObject var toolbarViewModel: ToolbarVM
    
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
            HStack {
                ToolView(viewModel: ToolVM(tool: Tool(name: toolbarViewModel.firstPenSettings.name,
                                                             onClick: {toolbarViewModel.setActivePenTool(settings: toolbarViewModel.firstPenSettings)},
                                                             onLongPress: {
                    toolbarViewModel.setActivePenTool(settings: toolbarViewModel.firstPenSettings)
                    toolbarViewModel.editActivePenSettings()},
                                                             icon: Image(systemName: "pencil.tip"),
                                                             tint: Color(toolbarViewModel.firstPenSettings.color),
                                                             isSelected: toolbarViewModel.activeToolName == toolbarViewModel.firstPenSettings.name)))
                
                ToolView(viewModel: ToolVM(tool: Tool(name: toolbarViewModel.secondPenSettings.name,
                                                             onClick: {toolbarViewModel.setActivePenTool(settings: toolbarViewModel.secondPenSettings)},
                                                             onLongPress: {
                    toolbarViewModel.setActivePenTool(settings: toolbarViewModel.secondPenSettings)
                    toolbarViewModel.editActivePenSettings()},
                                                             icon: Image(systemName: "pencil.tip"),
                                                             tint: Color(toolbarViewModel.secondPenSettings.color),
                                                             isSelected: toolbarViewModel.activeToolName == toolbarViewModel.secondPenSettings.name)))
                
                ToolView(viewModel: ToolVM(tool: Tool(name: toolbarViewModel.eraserSettings.name,
                                                             onClick: toolbarViewModel.setActiveEraserTool,
                                                             onLongPress: {print("Eraser Long Pressed")},
                                                             icon: Image(systemName: "eraser"),
                                                             tint: .black,
                                                             isSelected: toolbarViewModel.activeToolName == toolbarViewModel.eraserSettings.name)))
                
                Spacer()
            }
        }
        .background(Color.gray)
        .overlay(
            GeometryReader { toolbarGeo in
                // Capture the toolbar height inside this reader
                Color.clear
                    .onAppear {
                        toolbarViewModel.toolbarHeight = toolbarGeo.size.height
                    }
                    .frame(width: 0, height: 0) // Don't display this view, just use it for size calculation
            })
    }
}
