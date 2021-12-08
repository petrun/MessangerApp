//
//  UpdateProfileHandler.swift
//  MessangerApp
//
//  Created by andy on 03.12.2021.
//

import UIKit

private struct UpdateProfileData: Encodable {
    let name: String
    var profileImageUrl: URL?
}

protocol UpdateProfileHandlerProtocol {
    func updateProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    )
}

class UpdateProfileHandler {
    private let fileStorage: FileStorageProtocol
    private let userStorage: UserStorageProtocol

    init(fileStorage: FileStorageProtocol, userStorage: UserStorageProtocol) {
        self.fileStorage = fileStorage
        self.userStorage = userStorage
    }
}

extension UpdateProfileHandler: UpdateProfileHandlerProtocol {
    func updateProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    ) {
        var data = UpdateProfileData(name: name, profileImageUrl: nil)

        if let image = image {
            fileStorage.uploadImage(image: image, folder: "avatars") { [weak self] result in
                switch result {
                case .success(let url):
                    data.profileImageUrl = url
                    self?.updateUserData(uid: uid, data: data, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            updateUserData(uid: uid, data: data, completion: completion)
        }
    }

    private func updateUserData(uid: String, data: UpdateProfileData, completion: @escaping (Error?) -> Void) {
        do {
            userStorage.updateUser(
                uid: uid,
                data: try DictionaryEncoder().encode(data),
                completion: completion
            )
        } catch {
            completion(error)
        }
    }
}
