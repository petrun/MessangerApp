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
    var currentSender: Sender { get }
    var messagesCount: Int { get }
    var chatTitle: String { get }

    func start()
    func messageForItem(at indexPath: IndexPath) -> MessageType
//    func sendMessage(_ outgoingMessage: OutgoingMessage)
    func loadMoreMessages(completion: @escaping () -> Void)
    func isTyping()

    //send messages
    func sendMessage(text: String)
    func sendMessage(image: UIImage)
    func sendMessage(video: Video)
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
    private let sendMessageHandler: SendMessageHandlerProtocol

    // Typing
    private let typingService: TypingServiceProtocol
    private var typingListener: ListenerRegistration?
    private var typingCounter = 0

//    var displayingMessagesCount = 0

    init(
        chat: Chat,
        authService: AuthServiceProtocol,
        messageStorage: MessageStorageProtocol,
        typingService: TypingServiceProtocol,
        sendMessageHandler: SendMessageHandlerProtocol
    ) {
        self.chat = chat
        self.authService = authService
        self.messageStorage = messageStorage
        self.typingService = typingService
        self.sendMessageHandler = sendMessageHandler

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

        if typingCounter > 0 {
            typingService.set(typing: false, chatId: chat.id!, userId: currentUser.uid)
        }
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

    func sendMessage(text: String) {
        sendMessageHandler.sendMessage(text: text, chat: chat, sender: currentSender)
    }

    func sendMessage(image: UIImage) {
        sendMessageHandler.sendMessage(image: image, chat: chat, sender: currentSender)
    }

    func sendMessage(video: Video) {
        sendMessageHandler.sendMessage(video: video, chat: chat, sender: currentSender)
    }

    func loadMoreMessages(completion: @escaping () -> Void) {
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
