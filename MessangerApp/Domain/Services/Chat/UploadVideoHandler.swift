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

enum UploadVideoError: Error {
    case emptyThumbOrVideoUrl
}

final class UploadVideoHandler {
    private let fileStorage: FileStorageProtocol

    init(fileStorage: FileStorageProtocol) {
        self.fileStorage = fileStorage
    }
}

extension UploadVideoHandler: UploadVideoHandlerProtocol {
    private class UploadResult {
        var thumbUrl: URL?
        var videoUrl: URL?
        var error: Error?
    }

    func uploadVideo(
        chatId: String,
        video: Video,
        completion: @escaping (Result<ThumbURLVideoURL, Error>) -> Void
    ) {
        let uploadResult = UploadResult()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        getThumbAndUpload(chatId: chatId, video: video) { result in
            switch result {
            case .success(let thumbUrl):
                uploadResult.thumbUrl = thumbUrl
            case .failure(let error):
                uploadResult.error = error
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getVideoAndUpload(chatId: chatId, video: video) { result in
            switch result {
            case .success(let videoUrl):
                uploadResult.videoUrl = videoUrl
            case .failure(let error):
                uploadResult.error = error
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            if let error = uploadResult.error {
                completion(.failure(error))
            }

            guard
                let thumbUrl = uploadResult.thumbUrl, let videoUrl = uploadResult.videoUrl
            else {
                completion(.failure(UploadVideoError.emptyThumbOrVideoUrl))
                return
            }

            completion(.success(ThumbURLVideoURL(thumbUrl: thumbUrl, videoUrl: videoUrl)))
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
