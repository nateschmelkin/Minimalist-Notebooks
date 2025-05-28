import SwiftUI

struct PenColorPicker: View {
    
    @ObservedObject var toolbarVM: ToolbarVM
    
    var body: some View {
        VStack {
            ColorPicker("Pen Color", selection: Binding(
                get: {
                    Color(UIColor(hex: toolbarVM.penPresets.first(where: {
                                            $0.name == toolbarVM.activeToolName
                                        })?.colorHex ?? "#000000"))
                },
                set: { newColor in
                    toolbarVM.updateActivePenColor(UIColor(newColor))
                }
            ))
            .padding()
        }
        .frame(width: 200)
        .background(Theme.appBackground)
    }
}

struct PenWidthPicker: View {
    
    @ObservedObject var toolbarVM: ToolbarVM
    
    var body: some View {
        VStack {
            Text("Pen Width")
                .font(.headline)

            Slider(
                value: Binding(
                    get: {
                        toolbarVM.penPresets.first(where: {
                            $0.name == toolbarVM.activeToolName
                        })?.width ?? 4.0
                    },
                    set: { newWidth in
                        toolbarVM.updateActivePenWidth(newWidth)
                    }
                ),
                in: 0.88...25.66
            )
            .padding()
        }
        .padding()
        .frame(width: 200)
        .background(Theme.appBackground)
    }
}
