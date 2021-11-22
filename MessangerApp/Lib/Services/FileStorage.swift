//
//  FileStorage.swift
//  MessangerApp
//
//  Created by andy on 15.11.2021.
//

import FirebaseStorage

typealias FileUploadCompletion = (Result<URL, Error>) -> Void

protocol FileStorageProtocol {
    func uploadImage(image: UIImage, folder: String, completion: @escaping FileUploadCompletion)
}

final class FileStorage {
    private let storage = Storage.storage().reference()

    // upload video
    // download

    private func uploadFile(data: Data, folder: String, completion: @escaping FileUploadCompletion) {
        let ref = storage.child(folder).child(NSUUID().uuidString)

        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(url!))
            }
        }
    }
}

extension FileStorage: FileStorageProtocol {
    func uploadImage(image: UIImage, folder: String, completion: @escaping FileUploadCompletion) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }

        uploadFile(data: imageData, folder: folder, completion: completion)
    }
}