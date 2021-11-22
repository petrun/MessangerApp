//
//  UploadVideoHandler.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import Foundation
import Gallery

typealias ThumbURLVideoURL = (thumbUrl: URL, videoUrl: URL)

protocol UploadVideoHandlerProtocol {
    func uploadVideo(
        chatId: String,
        video: Video,
        completion: @escaping (Result<ThumbURLVideoURL, Error>) -> Void
    )
}

final class UploadVideoHandler {
    private let fileStorage: FileStorageProtocol

    init(fileStorage: FileStorageProtocol) {
        self.fileStorage = fileStorage
    }
}

extension UploadVideoHandler: UploadVideoHandlerProtocol {
    func uploadVideo(
        chatId: String,
        video: Video,
        completion: @escaping (Result<ThumbURLVideoURL, Error>) -> Void
    ) {
        getThumbAndUpload(chatId: chatId, video: video) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let thumbUrl):
                self.getVideoAndUpload(chatId: chatId, video: video) { result in
                    switch result {
                    case .success(let videoUrl):
                        completion(.success(ThumbURLVideoURL(thumbUrl: thumbUrl, videoUrl: videoUrl)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getVideoAndUpload(chatId: String, video: Video, completion: @escaping (Result<URL, Error>) -> Void) {
        VideoEditor().process(video: video) { [weak self] _, url in
            guard let self = self, let url = url else { return }
            do {
                let data = try Data(contentsOf: url)
                self.fileStorage.uploadVideo(
                    video: data,
                    folder: "chat/\(chatId)/video",
                    completion: completion
                )
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func getThumbAndUpload(chatId: String, video: Video, completion: @escaping (Result<URL, Error>) -> Void) {
        video.generateThumbnail(size: CGSize(width: 240, height: 240)) { [weak self] thumb in
            guard let self = self, let thumb = thumb else { return }

            self.fileStorage.uploadImage(
                image: thumb,
                folder: "chat/\(chatId)/videoThumbs",
                completion: completion
            )
        }
    }
}
