//
//  UserSession.swift
//  MessangerApp
//
//  Created by andy on 28.11.2021.
//

import Foundation

protocol UserSessionProtocol {
    var user: User? { get set }
    var uid: String? { get }
    func restoreUserData(completion: @escaping (User?) -> Void)
}

class UserSession {
    var user: User?

    private let authService: AuthServiceProtocol
    private let userProfile: UserProfileProtocol

    init(authService: AuthServiceProtocol, userProfile: UserProfileProtocol) {
        self.authService = authService
        self.userProfile = userProfile
    }
}

extension UserSession: UserSessionProtocol {
    func restoreUserData(completion: @escaping (User?) -> Void) {
        guard let uid = authService.currentUserId else {
            completion(nil)
            return
        }
        userProfile.get(uid) { [weak self] user in
            guard let self = self else { return }

            self.user = user
            completion(user)
        }
    }

    var uid: String? {
        authService.currentUserId
    }
}
