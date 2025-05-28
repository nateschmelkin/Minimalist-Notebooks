import SwiftUI

struct ToolbarToolFactory {
    static func makeConfigs(from vm: ToolbarVM) -> [ToolConfig] {
        var configs: [ToolConfig] = []

        for pen in vm.penPresets {
            configs.append(ToolConfig(
                type: .penPreset(pen.name ?? ""),
                icon: Image(systemName: "pencil.line"),
                tint: Color(UIColor(hex: pen.colorHex ?? "#000000")),
                isSelected: vm.activeToolName == pen.name
            ))
        }
        
        configs.append(
            ToolConfig(type: .addPen, icon: Image(systemName: "pencil.tip.crop.circle.badge.plus"), tint: Theme.primary, isSelected: false)
        )
        
        if let highlighter = vm.highlighterPreset {
            configs.append(ToolConfig(
                type: .highlighter,
                icon: Image(systemName: "highlighter"),
                tint: Color(UIColor(hex: highlighter.colorHex ?? "#FFFFFF")),
                isSelected: vm.activeToolName == highlighter.name
            ))
        }

        if let eraser = vm.eraserPreset {
            configs.append(ToolConfig(
                type: .eraser,
                icon: Image(systemName: "eraser"),
                tint: .black,
                isSelected: vm.activeToolName == eraser.name
            ))
        }

        configs.append(contentsOf: [
            ToolConfig(type: .spacer, icon: Image(systemName: ""), tint: .clear, isSelected: false),
            ToolConfig(type: .colorPicker, icon: Image(systemName: "paintpalette"), tint: Theme.primary, isSelected: false),
            ToolConfig(type: .widthSlider, icon: Image(systemName: "line.3.horizontal.decrease.circle"), tint: Theme.primary, isSelected: false)
        ])

        return configs
    }
}
