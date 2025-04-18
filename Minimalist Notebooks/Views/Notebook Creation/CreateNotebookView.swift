import SwiftUI

struct CreateNotebookView : View {
    @ObservedObject var notebooksGridViewModel: CoverGridVM
    @StateObject private var createNotebookViewModel = CreateNotebookVM()
    
    @FocusState private var nameFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Notebook name", text: $createNotebookViewModel.notebookTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($nameFieldIsFocused)
                .padding()
            
            Button(action: {
                notebooksGridViewModel.addNotebook(notebookTitle: createNotebookViewModel.notebookTitle)
            }) {
                Text("Create Notebook")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .popover(isPresented: $notebooksGridViewModel.showNoNotebookNameWarning) {
                Text("Notebook name cannot be empty")
            }
            .padding()
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                nameFieldIsFocused = true
            }
        }
    }
}
