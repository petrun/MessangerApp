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
        let coordinator = LoginCoordinator(router: router, resolver: resolver)
        coordinator.present(animated: animated, onDismissed: onDismissed)
    }
}
