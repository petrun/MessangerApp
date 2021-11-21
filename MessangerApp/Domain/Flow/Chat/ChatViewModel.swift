//
//  ChatViewModel.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import Firebase
import MessageKit

protocol ChatViewModelDelegate: AnyObject {
    func reloadData()
    func updateTypingIndicator(_ isTyping: Bool)
}

protocol ChatViewModelProtocol {
    var delegate: ChatViewModelDelegate? { get set }
    var currentSender: Sender { get }
    var messagesCount: Int { get }
    var chatTitle: String { get }

    func start()
    func messageForItem(at indexPath: IndexPath) -> MessageType
    func sendMessage(kind: MessageKind)
    func loadMoreMassages(completion: @escaping () -> Void)
    func isTyping()
}

class ChatViewModel {
    weak var delegate: ChatViewModelDelegate?
    var chatTitle: String
    let currentSender: Sender

    private let messagesLimit = 20
    private let chat: Chat
    private let currentUser: User
    private let receiver: Sender
    private var messages: [MessageType] = []
    private let authService: AuthServiceProtocol
    private let messageStorage: MessageStorageProtocol

    // Typing
    private let typingService: TypingServiceProtocol
    private var typingListener: ListenerRegistration?
    private var typingCounter = 0

//    var displayingMessagesCount = 0

    init(
        chat: Chat,
        authService: AuthServiceProtocol,
        messageStorage: MessageStorageProtocol,
        typingService: TypingServiceProtocol
    ) {
        self.chat = chat
        self.authService = authService
        self.messageStorage = messageStorage
        self.typingService = typingService

        currentUser = authService.currentUser!
        receiver = Sender(senderId: chat.membersIds.first!, displayName: "Receiver")
        currentSender = Sender(senderId: currentUser.uid, displayName: currentUser.name)

        switch chat.type {
        case .privateChat: chatTitle = receiver.displayName
        }
    }

    deinit {
        // TODO: Remove listeners
        print("Deinit")

        typingService.set(typing: false, chatId: chat.id!, userId: currentUser.uid)
        typingListener?.remove()
    }

    func start() {
        // Set typing observer
        typingListener = typingService.createTypingObserver(
            chatId: chat.id!,
            currentUserId: currentUser.uid
        ) { [weak self] isTyping in
            self?.delegate?.updateTypingIndicator(isTyping)
        }

        getMessages()
    }

    private func getMessages() {
        messageStorage.getMessages(chat: chat, limit: messagesLimit, beforeMessage: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages
                self.delegate?.reloadData()
            case .failure(let error):
                print("Error get messages \(error.localizedDescription)")
            }

            self.addListenForNewMessages()
        }
    }

    private func addListenForNewMessages() {
        messageStorage.listenForNewMessages(
            chat: chat,
            lastMessage: messages.last
        ) { [weak self] result in
            guard let self = self else { return }

            print("LOAD NEW MESSAGE")

            switch result {
            case .success(let message):
                if self.messages.last?.messageId != message.messageId {
                    print("listenForNewMessages success", message)
                    self.messages.append(message)
                    self.delegate?.reloadData()
                }
            case .failure(let error):
                print("listenForNewMessages failure", error)
            }
        }
    }
}

extension ChatViewModel: ChatViewModelProtocol {
    var messagesCount: Int { messages.count }

    func messageForItem(at indexPath: IndexPath) -> MessageType {
        messages[indexPath.section]
    }

    func sendMessage(kind: MessageKind) {
        let message = Message(sender: currentSender, kind: kind)
        messageStorage.sendMessage(chat: chat, message: message)
//        delegate?.reloadData()
    }

//    for component in data {
//        let user = SampleData.shared.currentSender
//        if let str = component as? String {
//            let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
//            insertMessage(message)
//        } else if let img = component as? UIImage {
//            let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
//            insertMessage(message)
//        }
//    }

    func loadMoreMassages(completion: @escaping () -> Void) {
        guard let firstMessage = messages.first else {
            completion()
            return
        }

        messageStorage.getMessages(
            chat: chat,
            limit: messagesLimit,
            beforeMessage: firstMessage
        ) { [weak self] result in
            switch result {
            case .success(let newMessages):
                self?.messages.insert(contentsOf: newMessages, at: 0)
            case .failure(let error):
                print("Error loadMoreMassages \(error.localizedDescription)")
            }
            completion()
        }
    }

    func isTyping() {
        typingCounter += 1
        typingService.set(typing: true, chatId: chat.id!, userId: currentUser.uid)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }

            self.typingCounter -= 1

            if self.typingCounter <= 0 {
                self.typingService.set(
                    typing: false,
                    chatId: self.chat.id!,
                    userId: self.currentUser.uid
                )
            }
        }
    }
}
