//
//  AuthorizationCoordinator.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Swinject

protocol LoginCoordinatorDelegate: AnyObject {
    func showSignUp()
}

final class LoginCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(LoginViewController.self)!

        if let viewModel = viewController.viewModel as? LoginViewModel {
            viewModel.coordinatorHandler = self
        }

        navigationController.setViewControllers([viewController], animated: true)

        router.present(navigationController, animated: animated, onDismissed: onDismissed)
    }
}

extension LoginCoordinator: LoginCoordinatorDelegate {
    func showSignUp() {
        RegistrationCoordinator(
            router: NavigationRouter(navigationController: navigationController),
            resolver: resolver
        ).present(animated: true, onDismissed: nil)
    }
}
