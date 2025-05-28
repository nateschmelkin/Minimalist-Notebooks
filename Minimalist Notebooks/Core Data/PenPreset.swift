import CoreData
import PencilKit
import SwiftUI
import UIKit

extension PenPreset {
    var inkingTool: PKInkingTool {
        let ink = PKInkingTool.InkType(rawValue: inkType ?? "") ?? .pen
        let color = UIColor(hex: colorHex ?? "#000000")
        return PKInkingTool(ink, color: color, width: width)
    }
}

extension UIColor {
    func toHex() -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        let rgb = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255)
        return String(format: "#%06X", rgb)
    }

    convenience init(hex: String) {
        let hexSanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard hexSanitized.count == 6,
              Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(white: 0.0, alpha: 1.0) // fallback to black
            return
        }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
