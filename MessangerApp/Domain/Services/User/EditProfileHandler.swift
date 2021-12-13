//
//  EditProfileHandler.swift
//  MessangerApp
//
//  Created by andy on 03.12.2021.
//

import FirebaseFirestoreSwift
import UIKit

enum EditProfileError: Error {
    case cantRestoreUser
}

private struct EditProfileHandlerData: Encodable {
    let name: String
    var profileImageUrl: URL?
}

protocol EditProfileHandlerProtocol {
    func createProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    )

    func updateProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    )
}

class EditProfileHandler {
    private let fileStorage: FileStorageProtocol
    private let userSession: UserSessionProtocol
    private let userStorage: UserStorageProtocol

    init(
        fileStorage: FileStorageProtocol,
        userSession: UserSessionProtocol,
        userStorage: UserStorageProtocol
    ) {
        self.fileStorage = fileStorage
        self.userSession = userSession
        self.userStorage = userStorage
    }
}

extension EditProfileHandler: EditProfileHandlerProtocol {
    func createProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    ) {
        var user = User(uid: uid, name: name, createdAt: Date(), profileImageUrl: nil)

        if let image = image {
            fileStorage.uploadImage(image: image, folder: "avatars") { [weak self] result in
                switch result {
                case .success(let url):
                    user.profileImageUrl = url
                    self?.createUserData(uid: uid, user: user, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            createUserData(uid: uid, user: user, completion: completion)
        }
    }

    func updateProfile(
        uid: String,
        image: UIImage?,
        name: String,
        completion: @escaping (Error?) -> Void
    ) {
        var data = EditProfileHandlerData(name: name, profileImageUrl: nil)

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

    private func createUserData(uid: String, user: User, completion: @escaping (Error?) -> Void) {
        userStorage.createUserData(
            uid: uid,
            user: user
        ) { [weak self] error in
            if let error = error {
                completion(error)
                return
            }
            self?.userSession.restoreUserData { user in
                if user == nil {
                    completion(EditProfileError.cantRestoreUser)
                } else {
                    completion(nil)
                }
            }
        }
    }

    private func updateUserData(uid: String, data: EditProfileHandlerData, completion: @escaping (Error?) -> Void) {
        do {
            userStorage.updateUserData(
                uid: uid,
                data: try DictionaryEncoder().encode(data),
                completion: completion
            )
        } catch {
            completion(error)
        }
    }
}
