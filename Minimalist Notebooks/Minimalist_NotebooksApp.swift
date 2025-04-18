//
//  Minimalist_NotebooksApp.swift
//  Minimalist Notebooks
//
//  Created by Nate Schmelkin on 3/31/25.
//

import SwiftUI

@main
struct Minimalist_NotebooksApp: App {
    var body: some Scene {
        WindowGroup {
            CoverGridView()
        }
    }
}

#Preview(body: {
    CoverGridView()
})
