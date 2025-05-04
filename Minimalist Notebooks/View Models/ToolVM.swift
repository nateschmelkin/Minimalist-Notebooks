import SwiftUI

class ToolVM: ObservableObject {
    @Published var tool: Tool

    init(tool: Tool) {
        self.tool = tool
    }
}
