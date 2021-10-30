import UIKit

protocol RouterFactoryProtocol {
    func makeModalNavigationRouter(
        parentViewController: UIViewController,
        modalPresentationStyle: UIModalPresentationStyle
    ) -> Router
    func makeWindowRootRouter(window: UIWindow) -> Router
    func makeNavigationRouter(navigationController: UINavigationController) -> Router
}

final class RouterFactory: RouterFactoryProtocol {
    func makeModalNavigationRouter(
        parentViewController: UIViewController,
        modalPresentationStyle: UIModalPresentationStyle
    ) -> Router {
        ModalNavigationRouter(
            parentViewController: parentViewController,
            modalPresentationStyle: modalPresentationStyle
        )
    }

    func makeWindowRootRouter(window: UIWindow) -> Router {
        WindowRootRouter(window: window)
    }

    func makeNavigationRouter(navigationController: UINavigationController) -> Router {
        NavigationRouter(navigationController: navigationController)
    }
}
