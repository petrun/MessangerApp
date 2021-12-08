//
//  ProfileCoordinator.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject

protocol EditProfileCoordinatorDelegate: AnyObject {
    func dismiss()
}

final class EditProfileCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let user: User
    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(user: User, router: Router, resolver: Resolver) {
        self.user = user
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(EditProfileViewController.self, argument: user)!

        (viewController.viewModel as? EditProfileViewModel)?.coordinatorHandler = self

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension EditProfileCoordinator: EditProfileCoordinatorDelegate {
    func dismiss() {
        router.dismiss(animated: true)
    }
}
