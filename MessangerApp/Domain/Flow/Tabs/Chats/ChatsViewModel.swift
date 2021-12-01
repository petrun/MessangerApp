//
//  ChatsViewModel.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import FirebaseFirestore

protocol ChatsViewModelProtocol: AnyObject {
    var delegate: ChatsViewModelDelegate? { get set }
    func start()
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

    private var listenForChatsUpdates: ListenerRegistration?

    private let chatStorage: ChatStorageProtocol
    private let currentUser: User
    private let logger: LoggerService
    private let userProfile: UserProfileProtocol

    init(
        chatStorage: ChatStorageProtocol,
        logger: LoggerService,
        userProfile: UserProfileProtocol,
        userSession: UserSessionProtocol
    ) {
        self.chatStorage = chatStorage
        self.logger = logger
        self.userProfile = userProfile

        currentUser = userSession.user!
    }

    deinit {
        print("Chats Deinit")

        listenForChatsUpdates?.remove()
    }

    func start() {
        getChats()
    }

    private func getChats() {
        chatStorage.getChats(for: currentUser) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let chats):
                print("Chats loaded", chats.count)
                self.chats = chats
            case .failure(let error):
                print("Failure load chats", error)
            }

            self.addListenForChatsUpdates()
        }
    }

    private func addListenForChatsUpdates() {
        guard listenForChatsUpdates == nil else { return }

        print("CALL add addListenForNewMessages")

        listenForChatsUpdates = chatStorage.addListener(for: currentUser) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let change):
                switch change {
                case .added(let chat):
                    guard
                        !self.chats.contains(where: { $0.id == chat.id })
                    else { return }

                    print("CHAT ADDED", chat)
                    self.chats.insert(chat, at: 0)
                    self.delegate?.reloadData()
                case .modified(let chat):
                    guard
                        let index = self.chats.firstIndex(where: { $0.id == chat.id })
                    else { return }

                    print("CHAT MODIFIED", chat)
                    self.chats[index] = chat
                    self.chats.sort { $0.lastUpdateAt > $1.lastUpdateAt }
                    self.delegate?.reloadData()
                }
            case .failure(let error):
                print("listenForNewMessages failure", error)
            }
        }
    }
}

extension ChatsViewModel: ChatsViewModelProtocol {
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
