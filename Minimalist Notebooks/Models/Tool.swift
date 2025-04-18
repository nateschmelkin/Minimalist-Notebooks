import Foundation
import SwiftUI

struct Tool {
    var name: String
    var onClick: () -> Void
    var onLongPress: () -> Void
    var icon: Image
    var tint: Color
    var isSelected: Bool
}
