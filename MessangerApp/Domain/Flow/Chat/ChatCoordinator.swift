//
//  ChatCoordinator.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import Swinject

final class ChatCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let chat: Chat
    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()

    init(chat: Chat, router: Router, resolver: Resolver) {
        self.chat = chat
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        router.present(
            resolver.resolve(ChatViewController.self, argument: chat)!,
            animated: animated,
            onDismissed: onDismissed
        )
    }
}
