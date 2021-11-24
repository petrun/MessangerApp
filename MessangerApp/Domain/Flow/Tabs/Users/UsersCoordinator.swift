//
//  UsersCoordinator.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject

protocol UsersCoordinatorDelegate: AnyObject {
    func showChat(user: User)
//    func showProfile(user: User)
}

final class UsersCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router

    private let resolver: Resolver
    private lazy var navigationController = UINavigationController()
    private lazy var chatStorage = resolver.resolve(ChatStorageProtocol.self)!
    private lazy var authService = resolver.resolve(AuthServiceProtocol.self)!

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = resolver.resolve(UsersViewController.self)!

        if let viewModel = viewController.viewModel as? UsersViewModel {
            viewModel.coordinatorHandler = self
        }

        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension UsersCoordinator: UsersCoordinatorDelegate {
//    func showProfile(user: User) {
//        showChat(user: user)
////        print("showProfile")
////        ProfileCoordinator(
////            user: user,
////            router: self.router,
//////            NavigationRouter(navigationController: navigationController),
////            resolver: resolver
////        ).present(animated: true, onDismissed: nil)
//    }

    // TODO: - Refactoring, move logic to viewModel
    func showChat(user: User) {
        guard let currentUser = authService.currentUser else {
            print("Current user is empty")
            return
        }

        let chatUsers = [user, currentUser]

        chatStorage.getPrivateChat(for: chatUsers) { [weak self] result in
            switch result {
            case .success(let chat):
                print("Chat found \(chat)")
                self?.presentChat(chat: chat)
            case .failure(let error):
                switch error {
                case ChatStorageError.chatNotFound(let errorMessage):
                    print("Chat not found \(errorMessage)")
                    let chat = Chat(
                        type: ChatType.privateChat,
                        membersIds: chatUsers.map { $0.uid }
                    )
                    self?.chatStorage.createChat(chat: chat) { [weak self] result in
                        switch result {
                        case .success:
                            print("Chat created \(chat)")
                            self?.presentChat(chat: chat)
                        case .failure(let error):
                            print("Chat not created \(error)")
                        }
                    }
                default:
                    print("Can't init chat \(error.localizedDescription)")
                }
            }
        }


        // get or create chat for user
//        print("showChat")
//        ChatCoordinator(
//            user: user,
//            router: self.router,
//            resolver: resolver
//        ).present(animated: true, onDismissed: nil)
    }

    private func presentChat(chat: Chat) {
        ChatCoordinator(
            chat: chat,
            router: self.router,
            resolver: resolver
        ).present(animated: true, onDismissed: nil)
    }
}
