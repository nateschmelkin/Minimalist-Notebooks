import SwiftUI

class ToolVM: ObservableObject {
    @Published var tool: Tool

    // Provide a default Tool instance if none is passed
    init(tool: Tool = Tool(name: "Default Tool",
                           onClick: { print("Default Tool tapped") },
                           onLongPress: {print("Default Tool long pressed")},
                           icon: Image(systemName: "chevron.left"),
                           tint: .blue,
                           isSelected: true)) {
        self.tool = tool
    }
}
