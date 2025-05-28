import SwiftUI
import PencilKit
import CoreData

class ToolbarVM: ObservableObject {
    
    @Published var isShowingPenSettings: Bool = false
    
    @Published var activeTool: PKTool = PKInkingTool(.pen, color: .black, width: 4)
    @Published var activeToolName: String = ""
    
    @Published var penPresets: [PenPreset] = []
    @Published var highlighterPreset: HighlighterPreset?
    @Published var eraserPreset: EraserPreset?
    
    private var MAX_PENS: Int = 5
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadPresets()
        addDefaultPresetsIfNeeded()
    }
    
    @Published var toolbarHeight: CGFloat = 0
    
    func editActivePenSettings() {
        isShowingPenSettings = true
    }
    
    func setActivePen(pen: PenPreset) {
        activeTool = pen.inkingTool
        activeToolName = pen.name ?? "Unnamed Pen"
    }
    
    func setActiveEraser() {
        guard let eraser = eraserPreset else { return }
        activeTool = eraser.eraserTool
        activeToolName = eraser.name ?? "Eraser"
    }
    
    func setActiveHighlighter() {
        guard let highlighter = highlighterPreset else { return }
        activeTool = highlighter.highlighterTool
        activeToolName = highlighter.name ?? "Highlighter"
    }
    
    func loadPresets() {
        let request = PenPreset.fetchRequest()
        penPresets = (try? context.fetch(request)) ?? []

        let eraserRequest = EraserPreset.fetchRequest()
        eraserPreset = try? context.fetch(eraserRequest).first
        
        let highlighterRequest = HighlighterPreset.fetchRequest()
        highlighterPreset = try? context.fetch(highlighterRequest).first
    }
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save toolbar changes: \(error)")
        }
    }
    
    func updateActivePenColor(_ color: UIColor) {
        guard let index = penPresets.firstIndex(where: { $0.name == activeToolName }) else { return }
        penPresets[index].colorHex = color.toHex()
        saveChanges()
        setActivePen(pen: penPresets[index])
    }

    func updateActivePenWidth(_ width: CGFloat) {
        guard let index = penPresets.firstIndex(where: { $0.name == activeToolName }) else { return }
        penPresets[index].width = Double(width)
        saveChanges()
        setActivePen(pen: penPresets[index])
    }
    
    func addPen() {
        guard penPresets.count < MAX_PENS else { return }

        let existingNames = Set(penPresets.compactMap { $0.name })
        var index = 1
        var uniqueName = "Pen \(index)"

        while existingNames.contains(uniqueName) {
            index += 1
            uniqueName = "Pen \(index)"
        }

        let pen = PenPreset(context: context)
        pen.id = UUID()
        pen.name = uniqueName
        pen.inkType = "pen"
        pen.colorHex = UIColor.black.toHex()
        pen.width = 4

        saveChanges()
        loadPresets()
        
        if let newPen = penPresets.first(where: { $0.name == uniqueName }) {
            setActivePen(pen: newPen)
        }
    }

    
    func deletePen(named name: String) { // NEED PRETTIER WAY TO INDICATE CAN'T DELETE LAST PEN
        guard let index = penPresets.firstIndex(where: { $0.name == name }) else { return }
        guard penPresets.count > 1 else { return }
        let pen = penPresets.remove(at: index)
        context.delete(pen)
        saveChanges()
        loadPresets()
        
        if !activeToolName.isEmpty {
            setActivePen(pen: penPresets.last ?? PenPreset(context: context))
        }
    }

    
    func addDefaultPresetsIfNeeded() {
        let defaults: [(String, PKInkingTool.InkType, UIColor, Double)] = [
            ("Pen 1", .pen, .black, 4),
            ("Pen 2", .pen, .blue, 4),
            ("Pen 3", .pen, .red, 4),
        ]

        if penPresets.isEmpty {
            for (name, inkType, color, width) in defaults {
                let pen = PenPreset(context: context)
                pen.id = UUID()
                pen.name = name
                pen.inkType = inkType.rawValue
                pen.colorHex = color.toHex()
                pen.width = width
            }
        }
        
        if highlighterPreset == nil {
            let highlighter = HighlighterPreset(context: context)
            highlighter.name = "Highlighter"
            highlighter.width = 20
            highlighter.colorHex = UIColor.yellow.toHex()
            highlighterPreset = highlighter
        }

        if eraserPreset == nil {
            let eraser = EraserPreset(context: context)
            eraser.name = "Eraser"
            eraser.width = 100
            eraserPreset = eraser
        }
        saveChanges()
        loadPresets()
    }

}
