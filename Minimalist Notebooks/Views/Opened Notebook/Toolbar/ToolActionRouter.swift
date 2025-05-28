struct ToolActionRouter {
    static func handleTap(_ type: ToolType, vm: ToolbarVM, showColorPicker: inout Bool, showWidthSlider: inout Bool) {
        switch type {
        case .penPreset(let name):
            if let preset = vm.penPresets.first(where: { $0.name == name }) {
                vm.setActivePen(pen: preset)
            }
        case .eraser:
            vm.setActiveEraser()
        case .highlighter:
            vm.setActiveHighlighter()
        case .addPen:
            vm.addPen()
            showColorPicker = true
        case .colorPicker:
            showColorPicker = true
        case .widthSlider:
            showWidthSlider = true
        case .spacer:
            break
        }
    }

    static func handleDelete(_ type: ToolType, vm: ToolbarVM) {
        if case let .penPreset(name) = type {
            vm.deletePen(named: name)
        }
    }
}
