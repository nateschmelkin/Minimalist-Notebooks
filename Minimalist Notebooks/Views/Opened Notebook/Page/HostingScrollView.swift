import SwiftUI

struct HostingScrollView<Content: View>: UIViewRepresentable {
    private let content: Content

    init(
      @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical   = true
        scrollView.alwaysBounceHorizontal = true        // ← allow horizontal pan
        scrollView.showsVerticalScrollIndicator   = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = false

        // Host the SwiftUI view
        let hostVC = context.coordinator.hostingController
        let hostView = hostVC.view!
        hostView.translatesAutoresizingMaskIntoConstraints = false
        hostView.backgroundColor = .clear

        // Keep a reference so delegate can return it
        context.coordinator.hostView = hostView

        scrollView.addSubview(hostView)

        NSLayoutConstraint.activate([
          // pin content to scrollable area
          hostView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
          hostView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
          hostView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
          hostView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

          // ─── NEW ─── force the content’s width to match the scroll-view’s visible width
          hostView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // whenever the SwiftUI body changes, swap in a new content tree
        context.coordinator.hostingController.rootView = content
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        let hostingController: UIHostingController<Content>
        weak var hostView: UIView?
        var parent: HostingScrollView

        init(parent: HostingScrollView) {
            self.parent = parent
            self.hostingController = UIHostingController(rootView: parent.content)
            super.init()
        }
    }
}
