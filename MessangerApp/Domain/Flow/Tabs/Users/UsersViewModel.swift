//
//  UsersViewModel.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Foundation

protocol UsersViewModelProtocol: AnyObject {
    var delegate: UsersViewModelDelegate? { get set }
    func loadUsers()
    func count() -> Int
    func itemForRowAt(indexPath: IndexPath) -> User
    func didSelectRowAt(indexPath: IndexPath)
}

protocol UsersViewModelDelegate: AnyObject {
    func reloadData()
}

final class UsersViewModel {
    weak var delegate: UsersViewModelDelegate?
    var coordinatorHandler: UsersCoordinatorDelegate?

    private let chatStorage: ChatStorageProtocol
    private let currentUser: User
    private let logger: LoggerService
    private var users: [User] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    private let userStorage: UserStorageProtocol


    init(
        chatStorage: ChatStorageProtocol,
        logger: LoggerService,
        userSession: UserSessionProtocol,
        userStorage: UserStorageProtocol
    ) {
        self.chatStorage = chatStorage
        self.logger = logger
        currentUser = userSession.user!
        self.userStorage = userStorage

        // Add test users
//        for i in 1...200 {
//            let user = User(uid: UUID().uuidString, name: "\(i)")
//            userStorage.addUser(user: user) { error in
//                print("user added \(i)")
//            }
//        }
    }
}

extension UsersViewModel: UsersViewModelProtocol {
    func loadUsers() {
        userStorage.getUsers(currentUserId: currentUser.uid) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                self?.logger.info("Failure load users \(error.localizedDescription)")
            }
        }
    }

    func count() -> Int {
        users.count
    }

    func itemForRowAt(indexPath: IndexPath) -> User {
        users[indexPath.row]
    }

    func didSelectRowAt(indexPath: IndexPath) {
        let recipient = itemForRowAt(indexPath: indexPath)

        chatStorage.getChat(for: [recipient, currentUser]) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let chat):
                self.logger.info("Chat found", context: chat)
                self.coordinatorHandler?.showChat(chat: chat)
            case .failure(let error):
                switch error {
                case ChatStorageError.chatNotFound(let errorMessage):
                    self.logger.info("Chat not found", context: errorMessage)

                    self.chatStorage.createChat(recipient: recipient) { [weak self] result in
                        switch result {
                        case .success(let chat):
                            self?.logger.info("Chat created", context: chat)
                            self?.coordinatorHandler?.showChat(chat: chat)
                        case .failure(let error):
                            self?.logger.error("Can't create chat", context: error)
                        }
                    }
                default:
                    self.logger.error("Can't init chat", context: error)
                }
            }
        }
    }
}
