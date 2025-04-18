//
//  NotebooksGridView.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI

struct CoverGridView: View {
    @StateObject private var notebooksGridViewModel = CoverGridVM()
    @State private var selectedNotebook: Notebook? // Tracks selected notebook
    @State private var selectedPageID: UUID? // Track selected page ID
    
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
                            .foregroundStyle(.white)
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            
                            // Show all notebooks
                            
                            ForEach(notebooksGridViewModel.notebooks) { notebook in
                                NotebookCoverView(title: notebook.title, onOpen: {
                                    selectedNotebook = notebook
                                    selectedPageID = notebook.pages.first?.id
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
                })
            } else {
                // Show the notebook if selected
                if let pageID = selectedPageID, let page = selectedNotebook?.pages.first(where: { $0.id == pageID }) {
                    OpenedNotebookView(notebookTitle: selectedNotebook?.title ?? "Untitled", pageID: page.id, onClose: {
                        selectedNotebook = nil
                        selectedPageID = nil
                    })
                    .id(pageID)
                } else {
                    // Handle case where no page is selected or available
                    Text("No page available")
                }
            }
        }
    }
}
