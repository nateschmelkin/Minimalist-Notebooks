import SwiftUI
import PencilKit

struct PenEditorView: View {
    @ObservedObject var activeToolSettings: PenSettings

    var body: some View {
        VStack(spacing: 20) {
            ColorPicker("Pen Color", selection: Binding(
                get: { Color(activeToolSettings.color) },
                set: { newColor in
                    // Convert SwiftUI Color back to UIColor.
                    activeToolSettings.color = UIColor(newColor)
                    print("New color: \(newColor)")
                    print("activePenSettings.color: \(activeToolSettings.color)")
                }
            ))
            
            // Width slider: Convert between CGFloat and Double as needed.
            Slider(
                value: Binding(
                    get: { Double(activeToolSettings.width) },
                    set: { newValue in
                        activeToolSettings.width = CGFloat(newValue)
                        print("New Pen Width: \(Int(newValue))")
                        print("Active Pen Width: \(Int(activeToolSettings.width))")
                    }
                ),
                in: 1...100
            ) {
                Text("Pen Width")
            }
            Text("Width: \(Int(activeToolSettings.width))")
        }
        .padding()
    }
}
