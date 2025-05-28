import SwiftUI
import CoreData

struct CreateNotebookView : View {
    @ObservedObject var notebookManager: NotebookManager
    @StateObject private var createNotebookViewModel = CreateNotebookVM()
    
    @FocusState private var nameFieldIsFocused: Bool
    
    @State private var selectedPaperType: PaperType = .blank
    
    var body: some View { // TODO ADD IN PAPER TYPES SINGLE SELECTOR
        VStack {
                List{
                TextField("Notebook name", text: $createNotebookViewModel.notebookTitle)
                    .focused($nameFieldIsFocused)
                
                Picker("Paper Type", selection: $selectedPaperType) {
                    Text("Blank").tag(PaperType.blank)
                    Text("Dotted").tag(PaperType.dots)
                    Text("Lined").tag(PaperType.lines)
                }
                HStack {
                    Spacer()
                    Group {
                        switch selectedPaperType {
                        case .blank:
                            Theme.pageBackground
                        case .dots:
                            DotGridView(zoomScale: 1)
                        case .lines:
                            LinedPaperView(zoomScale: 1)
                        }
                    }
                    .frame(width: 180, height: 240)
                }
            }
            
            Button(action: {
                notebookManager.createNotebook(title: createNotebookViewModel.notebookTitle, paperType: selectedPaperType)
            }) {
                Text("Create Notebook")
                    .font(.headline)
                    .padding()
                    .background(Theme.primary)
                    .foregroundStyle(Theme.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .popover(isPresented: $notebookManager.showNoNotebookNameWarning) {
                Text("Notebook name cannot be empty")
                    .foregroundStyle(Theme.error)
                    .padding()
            }
            .padding()
        }
    }
}
