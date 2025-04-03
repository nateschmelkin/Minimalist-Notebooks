//
//  NotebooksViewModel.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI

class NotebooksViewModel: ObservableObject {
    @Published var notebooks: [Notebook] = []
    
    func addNotebook() {
        // Create a new notebook with an initial page
        let newNotebook = Notebook(title: "New Notebook")
        notebooks.append(newNotebook)
    }
}
