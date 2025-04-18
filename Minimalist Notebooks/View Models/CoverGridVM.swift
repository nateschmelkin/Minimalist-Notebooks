//
//  NotebooksViewModel.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI

class CoverGridVM: ObservableObject {
    
    @Published var isShowingCreateNewNotebookView: Bool = false
    @Published var showNoNotebookNameWarning: Bool = false
    @Published var notebooks: [Notebook] = []
    
    func addNotebook(notebookTitle: String) {
        guard notebookTitle != "" else {
            showNoNotebookNameWarning = true
            return
        }
        // Create a new notebook with an initial page
        let newNotebook = Notebook(title: notebookTitle)
        notebooks.append(newNotebook)
        showNoNotebookNameWarning = false
        isShowingCreateNewNotebookView = false
    }
    
    func createNewNotebook() {
        isShowingCreateNewNotebookView = true
    }
}
