import CoreData
import PencilKit
import SwiftUI
import UIKit

extension EraserPreset {
    var eraserTool: PKEraserTool {
        PKEraserTool(
            PKEraserTool.EraserType.bitmap,
            width: width
        )
    }
}
