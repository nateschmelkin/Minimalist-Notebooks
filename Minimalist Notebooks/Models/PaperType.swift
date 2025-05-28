import Foundation

enum PaperType: String, CaseIterable, Identifiable {
    case blank
    case dots
    case lines

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .blank: return "Blank"
        case .dots: return "Dot Grid"
        case .lines: return "Lined"
        }
    }
}
