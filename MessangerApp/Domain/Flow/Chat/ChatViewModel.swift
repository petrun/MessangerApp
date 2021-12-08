//
//  ChatViewModel.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import Firebase
import Gallery
import MessageKit

protocol ChatViewModelDelegate: AnyObject {
    func reloadData()
    func updateTypingIndicator(_ isTyping: Bool)
}

protocol ChatViewModelProtocol {
    var delegate: ChatViewModelDelegate? { get set }
    var currentUser: User { get }
    var messagesCount: Int { get }
    var chatTitle: String { get }

    func start()
    func messageForItem(at indexPath: IndexPath) -> MessageType
    func loadMoreMessages(completion: @escaping () -> Void)
    func isTyping()
    func backButtonPressed()

    // Send messages
    func sendMessage(text: String)
    func sendMessage(image: UIImage)
    func sendMessage(video: Video)
}

class ChatViewModel {
    weak var delegate: ChatViewModelDelegate?
    var coordinatorHandler: ChatCoordinatorDelegate?
    var chatTitle: String
    let currentUser: User

    private let messagesLimit = 5

    private let chat: Chat
    private var messages: [Message] = []
    private let messageStorage: MessageStorageProtocol
    private let sendMessageHandler: SendMessageHandlerProtocol
    private var newMessagesListener: ListenerRegistration?

    // Typing
    private let typingService: TypingServiceProtocol
    private var typingListener: ListenerRegistration?
    private var typingCounter = 0

//    var displayingMessagesCount = 0

    init(
        chat: Chat,
        messageStorage: MessageStorageProtocol,
        typingService: TypingServiceProtocol,
        sendMessageHandler: SendMessageHandlerProtocol,
        userSession: UserSessionProtocol
    ) {
        self.chat = chat
        self.messageStorage = messageStorage
        self.typingService = typingService
        self.sendMessageHandler = sendMessageHandler

        currentUser = userSession.user!
        chatTitle = chat.title ?? "Empty chat title"
    }

    deinit {
        print("Deinit ChatViewModel")

        if typingCounter > 0 {
            typingService.set(typing: false, chatId: chat.id, userId: currentUser.uid)
        }

        // Remove listeners
        typingListener?.remove()
        newMessagesListener?.remove()
    }

    func start() {
        DispatchQueue.main.async {
            print("CALL START")
        }

        // Set typing observer
        typingListener = typingService.createTypingObserver(
            chatId: chat.id,
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
                print("LOAD MESSAGES \(messages.count) \(self.messages.count)")
                self.messages = messages
                self.delegate?.reloadData()
            case .failure(let error):
                print("Error get messages \(error.localizedDescription)")
            }

            self.addListenForNewMessages()
        }
    }

    private func addListenForNewMessages() {
        guard newMessagesListener == nil else { return }

        print("CALL add addListenForNewMessages")

        newMessagesListener = messageStorage.listenForNewMessages(
            chat: chat,
            lastMessage: messages.last
        ) { [weak self] result in
            guard let self = self else { return }

            print("LOAD NEW MESSAGE")

            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    guard self.messages.last?.messageId != message.messageId else { return }
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

    func sendMessage(text: String) {
        sendMessageHandler.sendMessage(text: text, chat: chat, sender: currentUser)
    }

    func sendMessage(image: UIImage) {
        sendMessageHandler.sendMessage(image: image, chat: chat, sender: currentUser)
    }

    func sendMessage(video: Video) {
        sendMessageHandler.sendMessage(video: video, chat: chat, sender: currentUser)
    }

    func loadMoreMessages(completion: @escaping () -> Void) {
        guard let firstMessage = messages.first else {
            completion()
            return
        }

        print("LOAD MORE MESSAGES")

        messageStorage.getMessages(
            chat: chat,
            limit: messagesLimit,
            beforeMessage: firstMessage
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let newMessages):
                newMessages.forEach { [weak self] newMessage in
                    guard
                        let self = self,
                        !self.messages.contains(newMessage)
                    else { return }
                    self.messages.insert(contentsOf: newMessages, at: 0)
                }
            case .failure(let error):
                print("Error loadMoreMassages \(error.localizedDescription)")
            }
            completion()
        }
    }

    func isTyping() {
        typingCounter += 1
        typingService.set(typing: true, chatId: chat.id, userId: currentUser.uid)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }

            self.typingCounter -= 1

            if self.typingCounter <= 0 {
                self.typingService.set(
                    typing: false,
                    chatId: self.chat.id,
                    userId: self.currentUser.uid
                )
            }
        }
    }

    func backButtonPressed() {
        coordinatorHandler?.dismiss()
    }
}
