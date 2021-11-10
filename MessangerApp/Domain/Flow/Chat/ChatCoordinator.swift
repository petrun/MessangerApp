//
//  ChatCoordinator.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import Swinject

final class ChatCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(ChatViewController.self)!

//        if let viewModel = viewController.viewModel as? RegistrationViewModel {
//            viewModel.coordinatorHandler = self
//        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}
