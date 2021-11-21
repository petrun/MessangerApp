//
//  ChatsViewModel.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Foundation

protocol ChatsViewModelProtocol: AnyObject {
    func loadChats()
//    func count() -> Int
//    func itemForRowAt(indexPath: IndexPath)
}

protocol ChatsViewModelDelegate: AnyObject {
    func reloadData()
}

final class ChatsViewModel {
    weak var delegate: ChatsViewModelDelegate?

    private var users: [User] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
//    private let authService: AuthServiceProtocol
//    private let logger: LoggerService
//    var coordinatorHandler: RegistrationCoordinatorDelegate?
//
//    init(authService: AuthServiceProtocol, logger: LoggerService) {
//        self.authService = authService
//        self.logger = logger
//    }
}

extension ChatsViewModel: ChatsViewModelProtocol {
    func loadChats() {
//        let userStorage = UserStorage()
//        userStorage.getPage(lastSnapshot: nil) { result in
//            switch result {
//            case .success(let users):
//                self.users = users
//                print("success")
//            case .failure(let error):
//                print("failure")
//                print(error)
//            }
//        }
    }
}
