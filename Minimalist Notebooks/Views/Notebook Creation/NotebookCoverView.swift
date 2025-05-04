import SwiftUI

struct NotebookCoverView: View {
    let title: String
    let onOpen: () -> Void // Closure to handle opening the notebook

    var body: some View {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(width: 180, height: 300)
            .background(Color.yellow.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        
            .onTapGesture {
                onOpen() // Trigger the opening of the notebook
            }
    }
}
