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

    private var users: [User] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    private let authService: AuthServiceProtocol
    private let userStorage: UserStorageProtocol
    private let logger: LoggerService

    init(
        authService: AuthServiceProtocol,
        userStorage: UserStorageProtocol,
        logger: LoggerService
    ) {
        self.authService = authService
        self.userStorage = userStorage
        self.logger = logger

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
        userStorage.getPage(
            lastSnapshot: nil,
            currentUserId: authService.currentUserId!,
            limit: 25
        ) { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("Failure load users \(error)")
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
        coordinatorHandler?.showChat(user: itemForRowAt(indexPath: indexPath))
    }
}
