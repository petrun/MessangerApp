//
//  UsersCoordinator.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject

protocol UsersCoordinatorDelegate: AnyObject {
    func showChat(chat: Chat)
}

final class UsersCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(UsersViewController.self)!

        if let viewModel = viewController.viewModel as? UsersViewModel {
            viewModel.coordinatorHandler = self
        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension UsersCoordinator: UsersCoordinatorDelegate {
    func showChat(chat: Chat) {
        ChatCoordinator(
            chat: chat,
            router: self.router,
            resolver: resolver
        ).present(animated: true, onDismissed: nil)
    }
}
