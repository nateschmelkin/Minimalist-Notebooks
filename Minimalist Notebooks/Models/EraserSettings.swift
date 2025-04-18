import Foundation
import SwiftUI
import PencilKit

struct EraserSettings {
    var name: String = "Eraser"
    var eraseMode: PKEraserTool.EraserType = .bitmap
    var width: CGFloat = 50
}
