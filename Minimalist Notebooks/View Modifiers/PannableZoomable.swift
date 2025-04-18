import SwiftUI

struct PannableZoomableModifier: ViewModifier {
    let minimumZoomScale: CGFloat
    let maximumZoomScale: CGFloat
    let doubleTapZoomScale: CGFloat
    let frameSize: CGSize

    // Gesture transformation states.
    @State private var lastTransform: CGAffineTransform = .identity
    @State private var transform: CGAffineTransform = .identity
    @State private var contentSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            // Use an overlay to measure the container size without affecting layout.
            .overlay(
                GeometryReader { innerProxy in
                    Color.clear
                        .onAppear {
                            let innerSize = innerProxy.size
                            print("On appear innerSize: \(innerSize)")
                            print("on appear outerSize: \(frameSize)")
                            contentSize = innerSize
                            updateTransform(for: innerSize)
                        }
                        .onChange(of: innerProxy.size) { newSize in
//                            if abs(frameSize.width - newSize.width) > 10 ||
//                               abs(frameSize.height - newSize.height) > 10 {
//                                resetTransform(to: newSize)
//                            }
                            contentSize = newSize
                            print("newInnerSize: \(newSize)")
                            print("innerSize: \(contentSize)")
                            print("FrameSize: \(frameSize)")
                        }
                }
            )
            .animatableTransformEffect(transform)
            .gesture(dragGesture, including: transform == .identity ? .none : .all)
            .gesture(doubleTapGesture)
            .gesture(magnifyGesture)
    }
    
    // MARK: - Gestures
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring) {
                    transform = lastTransform.translatedBy(
                        x: value.translation.width / transform.scaleX,
                        y: value.translation.height / transform.scaleY
                    )
                }
            }
            .onEnded { _ in finishGesture() }
    }
    
    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { value in
                let newTransform: CGAffineTransform = transform.isIdentity
                    ? .anchoredScale(scale: doubleTapZoomScale, anchor: value.location)
                    : .identity
                withAnimation(.linear(duration: 0.2)) {
                    transform = newTransform
                    lastTransform = newTransform
                }
            }
    }
    
    private var magnifyGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .onChanged { value in
                let scaleTransform = CGAffineTransform.anchoredScale(
                    scale: value.magnification,
                    anchor: value.startAnchor.scaledBy(contentSize)
                )
                withAnimation(.interactiveSpring) {
                    transform = lastTransform.concatenating(scaleTransform)
                }
            }
            .onEnded { _ in finishGesture() }
    }
    
    // MARK: - End-of-Gesture and Update Methods
    
    /// Called when any gesture ends to clamp the transform.
    private func finishGesture() {
        let newTransform = limitTransform(transform, frameSize: frameSize)
        withAnimation(.snappy(duration: 0.1)) {
            transform = newTransform
            lastTransform = newTransform
        }
    }
    
    /// Update the transform using the current container size.
    private func updateTransform(for containerSize: CGSize) {
        let newTransform = limitTransform(transform, frameSize: frameSize)
        transform = newTransform
        lastTransform = newTransform
    }
    
    /// Reset to a base transform (typically identity) when the container size changes significantly.
    private func resetTransform(to containerSize: CGSize) {
        withAnimation(.easeOut(duration: 0.2)) {
            let newTransform = limitTransform(.identity, frameSize: frameSize)
            transform = newTransform
            lastTransform = newTransform
        }
    }
    
    // MARK: - Clamping & Alignment Logic
    
    /// Clamps the given transform so that the scaled content stays within the container.
    /// If the scaled content is smaller than the container, center it by calculating the appropriate offset.
    private func limitTransform(_ transform: CGAffineTransform, frameSize: CGSize) -> CGAffineTransform {
        // Clamp scale to the allowed range.
        let clampedScale = max(min(transform.scaleX, maximumZoomScale), minimumZoomScale)
        
        // Calculate the scaled dimensions of the canvas.
        // NOTE: Make sure that your PageCanvasView applies `.aspectRatio(3/4, contentMode: .fit)`
        // before this modifier. That way, the background GeometryReader will measure the effective, letterboxed size.
        let scaledWidth = contentSize.width * clampedScale
        let scaledHeight = contentSize.height * clampedScale
        print("Scaled width, height: \(scaledWidth), \(scaledHeight)")
        // Use the container's dimensions (typically the frame in NotebookPageView, which is the area below the toolbar)
        let frameWidth = frameSize.width
        let frameHeight = frameSize.height
        
        // Horizontal logic:
        //   • If the scaled width exceeds the container width, allow horizontal pan.
        //   • Otherwise (or if the natural width is smaller), center it horizontally.
        let clampedTx: CGFloat = {
            if scaledWidth > frameWidth {
                let minTx = frameWidth - (scaledWidth - (contentSize.width - frameWidth)/2)  // negative value
                let maxTx: CGFloat = (contentSize.width - frameWidth)/2
                return min(max(transform.tx, minTx), maxTx)
            } else {
                return (contentSize.width - scaledWidth)/2
            }
        }()
        
        // Vertical logic: Use similar idea.
        let clampedTy: CGFloat = {
            if scaledHeight > frameHeight {
                let minTy = frameHeight - scaledHeight  // negative value
                let maxTy: CGFloat = 0
                return min(max(transform.ty, minTy), maxTy)
            } else {
                return (contentSize.height - scaledHeight)/2
            }
        }()
        
        var limitedTransform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
        limitedTransform.tx = clampedTx
        limitedTransform.ty = clampedTy
        print("limitedTransform.tx, ty: \(limitedTransform.tx), \(limitedTransform.ty)")
        return limitedTransform
    }

}

public extension View {
    @ViewBuilder
    func pannableZoomable(
        minZoomScale: CGFloat = 1,
        maxZoomScale: CGFloat = 5,
        doubleTapZoomScale: CGFloat = 3,
        frameSize: CGSize = CGSize(width: 0, height: 0)
    ) -> some View {
        modifier(PannableZoomableModifier(
            minimumZoomScale: minZoomScale,
            maximumZoomScale: maxZoomScale,
            doubleTapZoomScale: doubleTapZoomScale,
            frameSize: frameSize
        ))
    }
}

private extension View {
    /// Applies an animatable combination of scale and offset.
    @ViewBuilder
    func animatableTransformEffect(_ transform: CGAffineTransform) -> some View {
        scaleEffect(
            x: transform.scaleX,
            y: transform.scaleY,
            anchor: .zero
        )
        .offset(x: transform.tx, y: transform.ty)
    }
}

private extension UnitPoint {
    /// Scales the UnitPoint by the given size.
    func scaledBy(_ size: CGSize) -> CGPoint {
        CGPoint(x: self.x * size.width, y: self.y * size.height)
    }
}

private extension CGAffineTransform {
    /// Returns a transform that scales around a given anchor point.
    static func anchoredScale(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        CGAffineTransform(translationX: anchor.x, y: anchor.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -anchor.x, y: -anchor.y)
    }
    
    var scaleX: CGFloat { sqrt(a * a + c * c) }
    var scaleY: CGFloat { sqrt(b * b + d * d) }
}
