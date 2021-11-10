import Swinject

private extension Style {
    enum MainTabBar {
        static let messageImage = UIImage(systemName: "message")!
        static let groupsImage = UIImage(systemName: "person.3")!
        static let usersImage = UIImage(systemName: "person")!
        static let settingsImage = UIImage(systemName: "gearshape")!
    }
}

class MainTabBarCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let mainTabBarController = UITabBarController()
        mainTabBarController.tabBar.tintColor = .blue

        let routerFactory = resolver.resolve(RouterFactoryProtocol.self)!

        mainTabBarController.viewControllers = [
            createNavigationController(image: Style.MainTabBar.messageImage) {
                ChatsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            },
            createNavigationController(image: Style.MainTabBar.groupsImage) {
                ChatsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            },
            createNavigationController(image: Style.MainTabBar.usersImage) {
                ChatsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            },
            createNavigationController(image: Style.MainTabBar.settingsImage) {
                ChatsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            }
        ]

        router.present(mainTabBarController, animated: animated, onDismissed: onDismissed)
    }

    private func createNavigationController(
        image: UIImage,
        initCoordinator: (UINavigationController) -> Coordinator
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.image = image
//        navigationController.tabBarItem.title = "Home"
        navigationController.navigationBar.barTintColor = .white

        initCoordinator(navigationController).present(animated: false, onDismissed: nil)

        return navigationController
    }
}
