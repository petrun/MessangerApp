//
//  ChatsCoordinator.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Swinject

protocol ChatsCoordinatorDelegate: AnyObject {
    func showChat()
}

final class ChatsCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(ChatsViewController.self)!

//        if let viewModel = viewController.viewModel as? RegistrationViewModel {
//            viewModel.coordinatorHandler = self
//        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension ChatsCoordinator: ChatsCoordinatorDelegate {
    func showChat() {
    }
}
