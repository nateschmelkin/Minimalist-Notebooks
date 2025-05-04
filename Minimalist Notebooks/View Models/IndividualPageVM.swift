import SwiftUI
import PencilKit

class IndividualPageVM: ObservableObject {
    @Published var page: PageModel
    
    init(page: PageModel) {
        self.page = page
    }
}
