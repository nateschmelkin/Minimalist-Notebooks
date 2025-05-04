import SwiftUI

struct AddPageView: View {
    let onPress: () -> Void // Closure to handle opening the notebook

    var body: some View {
        Button(action: onPress) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}
