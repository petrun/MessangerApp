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

            let uid = userSession.uid
            let coordinator: Coordinator

            switch (uid, user) {
            case (_, let user?):
                print("Is logged in", user)
                coordinator = MainTabBarCoordinator(router: self.router, resolver: self.resolver)
            case (let uid?, _):
                print("Need complete profile")
                coordinator = CompleteProfileCoordinator(uid: uid, router: self.router, resolver: self.resolver)
            case (nil, nil):
                print("Is not logged in")
                coordinator = LoginCoordinator(router: self.router, resolver: self.resolver)
            }

            coordinator.present(animated: animated, onDismissed: onDismissed)
        }
    }
}
