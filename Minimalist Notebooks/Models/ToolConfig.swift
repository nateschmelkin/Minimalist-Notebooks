import Foundation
import SwiftUI

struct ToolConfig: Identifiable {
    var id: String { type.id }
    let type: ToolType
    let icon: Image
    let tint: Color
    let isSelected: Bool
}
