enum ToolType: Identifiable, Equatable {
    case penPreset(String)
    case highlighter
    case eraser
    case addPen
    case colorPicker
    case widthSlider
    case spacer
    
    var id: String {
        switch self {
        case .penPreset(let name): return "penPreset-\(name)"
        case .highlighter: return "highlighter"
        case .eraser: return "eraser"
        case .addPen: return "addPen"
        case .colorPicker: return "colorPicker"
        case .widthSlider: return "widthSlider"
        case .spacer: return "spacer"
        }
    }
}

extension ToolType {
    var isLeftSideTool: Bool {
        switch self {
        case .penPreset, .eraser, .highlighter, .addPen: return true
        default: return false
        }
    }
}
