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
        let authService = resolver.resolve(AuthServiceProtocol.self)!

        let coordinator: Coordinator = authService.currentUserId != nil ?
            MainTabBarCoordinator(router: router, resolver: resolver) :
            LoginCoordinator(router: router, resolver: resolver)

        coordinator.present(animated: animated, onDismissed: onDismissed)
    }
}
