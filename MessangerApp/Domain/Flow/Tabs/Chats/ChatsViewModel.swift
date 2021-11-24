//
//  ChatsViewModel.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Foundation

protocol ChatsViewModelProtocol: AnyObject {
    var delegate: ChatsViewModelDelegate? { get set }
    func loadChats()
    func filterChats(searchText: String)

    func count(isFiltering: Bool) -> Int
    func itemForRowAt(indexPath: IndexPath, isFiltering: Bool) -> Chat
    func didSelectRowAt(indexPath: IndexPath, isFiltering: Bool)
}

protocol ChatsViewModelDelegate: AnyObject {
    func reloadData()
}

final class ChatsViewModel {
    weak var delegate: ChatsViewModelDelegate?
    var coordinatorHandler: ChatsCoordinatorDelegate?

    private var chats: [Chat] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    private var filteredChats: [Chat] = [] {
        didSet {
            delegate?.reloadData()
        }
    }

    private let authService: AuthServiceProtocol
    private let chatStorage: ChatStorageProtocol
    private let currentUser: User
    private let logger: LoggerService
    private let userProfile: UserProfileProtocol

    init(
        authService: AuthServiceProtocol,
        chatStorage: ChatStorageProtocol,
        logger: LoggerService,
        userProfile: UserProfileProtocol
    ) {
        self.authService = authService
        self.chatStorage = chatStorage
        self.logger = logger
        self.userProfile = userProfile

        currentUser = authService.currentUser!
    }
}

extension ChatsViewModel: ChatsViewModelProtocol {
    func loadChats() {
        chatStorage.getChats(for: currentUser) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let chats):
                print("Chats loaded", chats.count)
                // TODO: - Need bulk load users for chats
                chats.forEach { [weak self] chat in
                    guard let self = self else { return }

                    switch chat.type {
                    case .privateChat:
                        self.userProfile.get(
                            chat.membersIds.first(where: { $0 != self.currentUser.uid })!
                        ) { [weak self] user in
                            guard let self = self, let user = user else { return }

                            var newChat = chat
                            newChat.title = user.name
                            newChat.imageUrl = user.profileImageUrl

                            self.chats.append(newChat)
                        }
                    }
                }
            case .failure(let error):
                print("Failure load chats \(error)")
            }
        }
    }

    func count(isFiltering: Bool) -> Int {
        isFiltering ? filteredChats.count : chats.count
    }

    func itemForRowAt(indexPath: IndexPath, isFiltering: Bool) -> Chat {
        isFiltering ? filteredChats[indexPath.row] : chats[indexPath.row]
    }

    func didSelectRowAt(indexPath: IndexPath, isFiltering: Bool) {
        coordinatorHandler?.showChat(chat: itemForRowAt(indexPath: indexPath, isFiltering: isFiltering))
    }

    func filterChats(searchText: String) {
        filteredChats = searchText.isEmpty ?
            chats :
            chats.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }

        delegate?.reloadData()
    }
}
