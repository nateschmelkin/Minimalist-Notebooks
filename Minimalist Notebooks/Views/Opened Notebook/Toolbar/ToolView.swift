import SwiftUI

struct ToolView: View {
    
    @ObservedObject var viewModel: ToolVM
    
    let squareSize: CGFloat = 48
    
    init(viewModel: ToolVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.tool.onClick()
        }) {
            viewModel.tool.icon
                .font(.title)
                .foregroundColor(viewModel.tool.tint)
                .padding(4)
                .frame(maxWidth: squareSize, maxHeight: squareSize)
                .background(
                    Color.cyan.opacity(viewModel.tool.isSelected ? 0.3 : 0))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        
        .simultaneousGesture(
            // Adjust minimumDuration as needed (e.g., 1 second)
            LongPressGesture()
                .onEnded { _ in
                    viewModel.tool.onLongPress()
                }
        )
    }
}

#Preview {
    ToolView(viewModel: ToolVM(tool: Tool(
        name: "Ballz",
        onClick: {print("big ballz pressed")},
        onLongPress: {print("big ballz held")},
        icon: Image(systemName: "plus"),
        tint: .cyan,
        isSelected: true)))
}
