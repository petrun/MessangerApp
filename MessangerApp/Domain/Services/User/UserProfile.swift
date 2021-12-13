//
//  UserProfile.swift
//  MessangerApp
//
//  Created by andy on 23.11.2021.
//

import Foundation

protocol UserProfileProtocol {
    func get(_ uid: String, useCache: Bool, completion: @escaping (User?) -> Void)
}

extension UserProfileProtocol {
    func get(_ uid: String, useCache: Bool = true, completion: @escaping (User?) -> Void) {
        get(uid, useCache: useCache, completion: completion)
    }
}

class UserProfile {
    private let cache: CacheProtocol
    private let userStorage: UserStorageProtocol

    init(cache: CacheProtocol, userStorage: UserStorageProtocol) {
        self.cache = cache
        self.userStorage = userStorage
    }
}

extension UserProfile: UserProfileProtocol {
    func get(_ uid: String, useCache: Bool = true, completion: @escaping (User?) -> Void) {
        if useCache, let cachedUser = cache.get(key: uid) as? User {
            completion(cachedUser)
            return
        }
        userStorage.getUser(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                if useCache {
                    self?.cache.set(key: user.uid, data: user)
                }
                completion(user)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
