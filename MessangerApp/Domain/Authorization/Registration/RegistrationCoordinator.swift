//
//  RegistrationCoordinator.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Swinject

protocol RegistrationCoordinatorDelegate: AnyObject {
    func backToLogin()
}

final class RegistrationCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(RegistrationViewController.self)!

        if let viewModel = viewController.viewModel as? RegistrationViewModel {
            viewModel.coordinatorDelegate = self
        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension RegistrationCoordinator: RegistrationCoordinatorDelegate {
    func backToLogin() {
        dismiss(animated: true)
    }
}
