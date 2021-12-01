import Swinject

private extension Style {
    enum MainTabBar {
        static let chatsImage = UIImage(systemName: "quote.bubble")!
        static let usersImage = UIImage(systemName: "person.2")!
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
            createNavigationController(image: Style.MainTabBar.chatsImage, title: L10n.Chats.title) {
                ChatsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            },
            createNavigationController(image: Style.MainTabBar.usersImage, title: L10n.Users.title) {
                UsersCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            },
            createNavigationController(image: Style.MainTabBar.settingsImage, title: L10n.Settings.title) {
                SettingsCoordinator(
                    router: routerFactory.makeNavigationRouter(navigationController: $0),
                    resolver: resolver
                )
            }
        ]

        router.present(mainTabBarController, animated: animated, onDismissed: onDismissed)
    }

    private func createNavigationController(
        image: UIImage,
        title: String,
        initCoordinator: (UINavigationController) -> Coordinator
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        navigationController.navigationBar.barTintColor = .white

        initCoordinator(navigationController).present(animated: false, onDismissed: nil)

        return navigationController
    }
}
