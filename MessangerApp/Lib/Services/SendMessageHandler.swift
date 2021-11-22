//
//  SendMessageHandler.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import AVFoundation
import Gallery
import UIKit

protocol SendMessageHandlerProtocol {
    func sendMessage(text: String, chat: Chat, sender: Sender)
    func sendMessage(image: UIImage, chat: Chat, sender: Sender)
    func sendMessage(video: Video, chat: Chat, sender: Sender)
}

class SendMessageHandler {
    private let fileStorage: FileStorageProtocol
    private let logger: LoggerService
    private let messageStorage: MessageStorageProtocol
    private let uploadVideoHandler: UploadVideoHandlerProtocol

    init(
        fileStorage: FileStorageProtocol,
        logger: LoggerService,
        messageStorage: MessageStorageProtocol,
        uploadVideoHandler: UploadVideoHandlerProtocol
    ) {
        self.fileStorage = fileStorage
        self.logger = logger
        self.messageStorage = messageStorage
        self.uploadVideoHandler = uploadVideoHandler
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

        fileStorage.uploadImage(image: image, folder: "chat/\(chatId)/images") { [weak self] result in
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

    func sendMessage(video: Video, chat: Chat, sender: Sender) {
        guard let chatId = chat.id else {
            logger.error("Empty chatId")
            return
        }

        uploadVideoHandler.uploadVideo(chatId: chatId, video: video) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let urls):
                self.messageStorage.sendMessage(
                    chat: chat,
                    message: Message(
                        sender: sender,
                        kind: .video(VideoMediaItem(
                                        thumbUrl: urls.thumbUrl,
                                        videoUrl: urls.videoUrl
                        ))
                    )
                )
            case .failure(let error):
                self.logger.error(error)
            }
        }
    }
}
