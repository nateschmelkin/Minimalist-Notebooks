import SwiftUI

struct NotebookCoverView: View {
    let notebook: Notebook
    let onOpen: () -> Void // Closure to handle opening the notebook
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onOpen) {
                VStack {
                    Text(notebook.title!)
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                }
                .padding()
                .frame(width: 180, height: 240)
                .background(Theme.highlight) // TODO CHANGE FOR A STORED NOTEBOOK COLOR
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .contextMenu {
                Button("Delete", role: .destructive, action: onDelete)
                // Add more items here later:
                // Button("Rename", action: ...)
            }
        }
    }
}
