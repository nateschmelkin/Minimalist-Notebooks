import SwiftUI
import PencilKit

class ToolbarVM: ObservableObject {
    
    @Published var isShowingPenSettings: Bool = false
    
    @Published var activeTool: PKTool = PKInkingTool(.pen, color: .black, width: 4)
    @Published var activeToolSettings: PenSettings = PenSettings(name: "Pen 1", penType: .pen, color: UIColor(.black), width: 4)
    @Published var activeToolName: String = "Pen"
    @Published var activeToolAnchor: UnitPoint = .center
    
    //Pens
    @Published var firstPenSettings: PenSettings = PenSettings(name: "Pen 1", penType: .pen, color: UIColor(.black), width: 4)
    @Published var secondPenSettings: PenSettings = PenSettings(name: "Pen 2", penType: .pen, color: UIColor(.blue), width: 4)
    @Published var thirdPenSettings: PenSettings = PenSettings(name: "Pen 3", penType: .pen, color: UIColor(.red), width: 4)
    
    @Published var eraserSettings: EraserSettings = EraserSettings(name: "Eraser", eraseMode: .bitmap, width: 100)
    
    @Published var toolbarHeight: CGFloat = 0
    
    //TODO SEPARATE VIEW MODELS BETWEEN THE PAGE AND THE TOOLBAR AS THEY ARE FUNDAMENTALLY DIFFERENT VIEWS. TOOLBAR WILL
    //PERSIST THROUGH ANY PAGE SO ITS INK AND WIDTH DATA SHOULD NOT BE CALLED THROUGH A PAGE
    func editActivePenSettings() {
        isShowingPenSettings = true
    }
    
    func setActivePenTool(settings: PenSettings) {
        activeTool = PKInkingTool(settings.inkType, color: settings.color, width: settings.width)
        activeToolName = settings.name
        activeToolSettings = settings
    }
    
    func setActiveEraserTool() {
        activeTool = PKEraserTool(eraserSettings.eraseMode, width: eraserSettings.width)
        activeToolName = eraserSettings.name
    }
}
