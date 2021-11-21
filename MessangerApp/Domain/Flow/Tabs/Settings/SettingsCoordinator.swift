//
//  SettingsCoordinator.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Swinject

protocol SettingsCoordinatorDelegate: AnyObject {
    func logout()
    func showLink()
    func showProfile()
}

final class SettingsCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(SettingsViewController.self)!

        if let viewModel = viewController.viewModel as? SettingsViewModel {
            viewModel.coordinatorHandler = self
        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension SettingsCoordinator: SettingsCoordinatorDelegate {
    func logout() {
        print("Touch logout")
    }

    func showLink() {
        let vc = UIViewController()
        router.present(vc, animated: true)
//        navigationController.pushViewController(vc, animated: true)
        print("Show link")
    }

    func showProfile() {
        print("Touch showProfile")
    }
}
