//
//  AuthorizationCoordinator.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation
import Swinject

protocol LoginCoordinatorDelegate: AnyObject {

}

final class LoginCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(LoginViewController.self)!

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}
