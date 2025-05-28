import SwiftUI

struct ToolbarToolButton: View {
    let config: ToolConfig
    let onTap: () -> Void
    let onDelete: (() -> Void)?

    var body: some View {
        config.icon
            .font(.title)
            .foregroundColor(config.tint)
            .frame(width: 40, height: 40)
            .background(
                Theme.primary.opacity(config.isSelected ? 0.3 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                onTap()
            }
            .contextMenu {
                if let onDelete = onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete Pen Preset", systemImage: "trash")
                    }
                }
            }
    }
}
