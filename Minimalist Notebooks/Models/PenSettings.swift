import Foundation
import SwiftUI
import PencilKit

class PenSettings: ObservableObject {
    @Published var name: String
    @Published var inkType: PKInkingTool.InkType
    @Published var color: UIColor
    @Published var width: CGFloat
    
    init(name: String, penType: PKInkingTool.InkType, color: UIColor, width: CGFloat) {
        self.name = name
        self.inkType = penType
        self.color = color
        self.width = width
    }
}
