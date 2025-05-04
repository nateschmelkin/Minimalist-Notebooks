//
//  NotebooksGridView.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI
import PencilKit

struct CoverGridView: View {
    @StateObject private var notebooksGridViewModel = CoverGridVM()
    
    let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 40)
    ]
    
    var body: some View {
        ZStack {
            // Show grid if no notebook is selected
            if notebooksGridViewModel.selectedNotebook == nil {
                ScrollView {
                    VStack {
                        Text("Notebooks")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            
                            // Show all notebooks
                            
                            ForEach(notebooksGridViewModel.notebooks) { notebook in
                                NotebookCoverView(title: notebook.title, onOpen: {
                                    notebooksGridViewModel.selectedNotebook = notebook
                                })
                            }
                            
                            // Make button in last slot
                            Button(action: {
                                notebooksGridViewModel.createNewNotebook()
                            }) {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.blue)
                                    
                                    Text("New Notebook")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                                .frame(width: 180, height: 300)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $notebooksGridViewModel.isShowingCreateNewNotebookView, content: {
                    CreateNotebookView(notebooksGridViewModel: notebooksGridViewModel)
                        .onDisappear {
                            notebooksGridViewModel.selectedNotebook = notebooksGridViewModel.notebooks.last
                        }
                })
            } else {
                OpenedNotebookView(
                    notebookVM: NotebookVM(notebook: notebooksGridViewModel.selectedNotebook!), 
                    onClose: {
                        notebooksGridViewModel.selectedNotebook = nil
                    }
                )
            }
        }
    }
}

//Notebook(title: "Multiple Pages", pages: [PageModel(pageNumberIndex: 0, drawing: PKDrawing()), PageModel(pageNumberIndex: 0, drawing: PKDrawing())])
