import UIKit

final class WindowRootRouter {
    public let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }
}

extension WindowRootRouter: Router {
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: ( ()->Void)? ) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    public func dismiss(animated: Bool) {
        // don't do anything
    }
}
