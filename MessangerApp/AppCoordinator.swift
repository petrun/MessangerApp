//
//  AppCoordinator.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation
import Swinject

final class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let userSession = resolver.resolve(UserSessionProtocol.self)!

        // TODO: - Show loader while load user data
        userSession.restoreUserData { [weak self] user in
            guard let self = self else { return }

            let coordinator: Coordinator = user != nil ?
                MainTabBarCoordinator(router: self.router, resolver: self.resolver) :
                LoginCoordinator(router: self.router, resolver: self.resolver)

            coordinator.present(animated: animated, onDismissed: onDismissed)
        }
    }
}
