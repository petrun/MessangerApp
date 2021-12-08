//
//  CompleteProfileCoordinator.swift
//  MessangerApp
//
//  Created by andy on 08.12.2021.
//

import Swinject

protocol CompleteProfileCoordinatorDelegate: AnyObject {
    func showMainPage()
}

final class CompleteProfileCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let uid: String
    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(uid: String, router: Router, resolver: Resolver) {
        self.uid = uid
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(CompleteProfileViewController.self, argument: uid)!

        (viewController.viewModel as? CompleteProfileViewModel)?.coordinatorHandler = self

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension CompleteProfileCoordinator: CompleteProfileCoordinatorDelegate {
    func showMainPage() {
        MainTabBarCoordinator(
            router: WindowRootRouter(window: UIApplication.shared.windows.first!),
            resolver: resolver
        ).present(animated: true, onDismissed: nil)
    }
}
