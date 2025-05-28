import CoreData
import PencilKit
import SwiftUI
import UIKit

extension HighlighterPreset {
    var highlighterTool: PKInkingTool {
        PKInkingTool(.marker, color: UIColor(hex: colorHex ?? "#000000"), width: width)
    }
}
