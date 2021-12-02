//
//  SendMessageHandler.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import AVFoundation
import Gallery
import MessageKit
import UIKit

protocol SendMessageHandlerProtocol {
    func sendMessage(text: String, chat: Chat, sender: User)
    func sendMessage(image: UIImage, chat: Chat, sender: User)
    func sendMessage(video: Video, chat: Chat, sender: User)
}

class SendMessageHandler {
    private let chatStorage: ChatStorageProtocol
    private let fileStorage: FileStorageProtocol
    private let logger: LoggerService
    private let messageStorage: MessageStorageProtocol
    private let uploadVideoHandler: UploadVideoHandlerProtocol

    init(
        chatStorage: ChatStorageProtocol,
        fileStorage: FileStorageProtocol,
        logger: LoggerService,
        messageStorage: MessageStorageProtocol,
        uploadVideoHandler: UploadVideoHandlerProtocol
    ) {
        self.chatStorage = chatStorage
        self.fileStorage = fileStorage
        self.logger = logger
        self.messageStorage = messageStorage
        self.uploadVideoHandler = uploadVideoHandler
    }

    private func sendMessage(chat: Chat, sender: User, kind: MessageKind) {
        messageStorage.sendMessage(chat: chat, sender: sender, kind: kind) { [weak self] result in
            switch result {
            case .success(let message):
                self?.chatStorage.setLastMessage(chat: chat, message: message) { [weak self] error in
                    if let error = error {
                        self?.logger.error("Can't set last message \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self?.logger.error("Can't send message \(error.localizedDescription)")
            }
        }
    }
}

extension SendMessageHandler: SendMessageHandlerProtocol {
    func sendMessage(text: String, chat: Chat, sender: User) {
        sendMessage(chat: chat, sender: sender, kind: .text(text))
    }

    func sendMessage(image: UIImage, chat: Chat, sender: User) {
        fileStorage.uploadImage(image: image, folder: "chat/\(chat.id)/images") { [weak self] result in
            switch result {
            case .success(let url):
                self?.sendMessage(
                    chat: chat,
                    sender: sender,
                    kind: .photo(ImageMediaItem(imageURL: url))
                )
            case .failure(let error):
                self?.logger.error("Can't send message with image \(error.localizedDescription)")
            }
        }
    }

    func sendMessage(video: Video, chat: Chat, sender: User) {
        uploadVideoHandler.uploadVideo(chatId: chat.id, video: video) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let urls):
                self.sendMessage(
                    chat: chat,
                    sender: sender,
                    kind: .video(VideoMediaItem(
                                    thumbUrl: urls.thumbUrl,
                                    videoUrl: urls.videoUrl
                    ))
                )
            case .failure(let error):
                self.logger.error(error)
            }
        }
    }
}
