//
//  SendMessageHandler.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import UIKit

protocol SendMessageHandlerProtocol {
    func sendMessage(text: String, chat: Chat, sender: Sender)
    func sendMessage(image: UIImage, chat: Chat, sender: Sender)
}

class SendMessageHandler {
    private let fileStorage: FileStorageProtocol
    private let logger: LoggerService
    private let messageStorage: MessageStorageProtocol

    init(
        fileStorage: FileStorageProtocol,
        logger: LoggerService,
        messageStorage: MessageStorageProtocol
    ) {
        self.fileStorage = fileStorage
        self.logger = logger
        self.messageStorage = messageStorage
    }
}

extension SendMessageHandler: SendMessageHandlerProtocol {
    func sendMessage(text: String, chat: Chat, sender: Sender) {
        messageStorage.sendMessage(chat: chat, message: Message(sender: sender, kind: .text(text)))
    }

    func sendMessage(image: UIImage, chat: Chat, sender: Sender) {
        guard let chatId = chat.id else {
            logger.error("Empty chatId")
            return
        }

        fileStorage.uploadImage(image: image, folder: "chat/\(chatId)") { [weak self] result in
            switch result {
            case .success(let url):
                self?.messageStorage.sendMessage(
                    chat: chat,
                    message: Message(sender: sender, kind: .photo(ImageMediaItem(imageURL: url)))
                )
            case .failure(let error):
                self?.logger.error("Can't send message with image \(error.localizedDescription)")
            }
        }
    }
}
