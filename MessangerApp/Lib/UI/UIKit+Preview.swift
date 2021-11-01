import SwiftUI

extension UIView {
    @available(iOS 13, *)
    func embedForPreview() -> some View {
        ViewPreviewer(contentView: self).edgesIgnoringSafeArea(.all)
    }
}

@available(iOS 13, *)
private struct ViewPreviewer: UIViewControllerRepresentable {
    let contentView: UIView

    func makeUIViewController(context _: Context) -> UIViewController {
        ViewControllerContainer(view: contentView)
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

private class ViewControllerContainer: UIViewController {
    init(view: UIView) {
        super.init(nibName: nil, bundle: nil)
        super.view = view
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
