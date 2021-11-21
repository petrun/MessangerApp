//
//  ProfileCoordinator.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject

final class ProfileCoordinator: Coordinator {
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
        let viewController = resolver.resolve(ProfileViewController.self, argument: user)!
//        container.resolve(Animal.self, argument: "Spirit")!

//        if let viewModel = viewController.viewModel as? RegistrationViewModel {
//            viewModel.coordinatorHandler = self
//        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}
