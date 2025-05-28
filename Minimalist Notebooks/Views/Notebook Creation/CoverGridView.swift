//
//  NotebooksGridView.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI
import PencilKit

struct CoverGridView: View {
    @StateObject var notebookManager: NotebookManager
    
    @State var selectedNotebook: Notebook?
    
    @State private var notebookToDelete: Notebook?
    @State private var showingDeleteConfirmation = false

    init() {
        _notebookManager = StateObject(wrappedValue: NotebookManager(
            context: PersistenceController.shared.container.viewContext
        ))
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 40)
    ]
    
    var body: some View {
        ZStack {
            // Show grid if no notebook is selected
            if selectedNotebook == nil {
                ScrollView {
                    VStack {
                        Text("Notebooks")
                            .font(.largeTitle)
                            .foregroundStyle(Theme.textPrimary)
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            
                            // Show all notebooks
                            
                            ForEach(notebookManager.notebooks, id: \.id) { notebook in
                                NotebookCoverView(
                                    notebook: notebook,
                                    onOpen: {
                                        selectedNotebook = notebook
                                    },
                                    onDelete: {
                                        notebookToDelete = notebook
                                        notebookManager.deleteNotebook(notebook)
                                        if selectedNotebook == notebook {
                                            selectedNotebook = nil
                                        }
                                        notebookToDelete = nil
                                    }
                                )
                            }
                            
                            // Make button in last slot
                            Button(action: {
                                notebookManager.addNotebook()
                            }) {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(Theme.primary)
                                    
                                    Text("New Notebook")
                                        .font(.headline)
                                        .foregroundStyle(Theme.textPrimary)
                                }
                                .frame(width: 180, height: 240)
                                .background(Theme.secondary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $notebookManager.isShowingCreateNewNotebookView, content: {
                    CreateNotebookView(notebookManager: notebookManager)
                        .onDisappear {
                            selectedNotebook = notebookManager.notebooks.last
                        }
                })
            } else {
                OpenedNotebookView(
                    notebook: selectedNotebook!,
                    notebookManager: notebookManager,
                    onClose: {
                        selectedNotebook = nil
                    }
                )
            }
        }
        .background(Theme.appBackground)
    }
}

#Preview {
    CoverGridView()
}
