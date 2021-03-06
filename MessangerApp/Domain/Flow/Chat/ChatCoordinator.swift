//
//  ChatCoordinator.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import Swinject

protocol ChatCoordinatorDelegate: AnyObject {
    func dismiss()
}

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
        let viewController = resolver.resolve(ChatViewController.self, argument: chat)!

        (viewController.viewModel as? ChatViewModel)?.coordinatorHandler = self

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension ChatCoordinator: ChatCoordinatorDelegate {
    func dismiss() {
        router.dismiss(animated: true)
    }
}
