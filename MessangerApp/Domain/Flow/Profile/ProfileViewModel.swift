//
//  ProfileViewModel.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import Foundation

protocol ProfileViewModelProtocol {
}

class ProfileViewModel: ProfileViewModelProtocol {
    private let user: User

    init(user: User) {
        self.user = user
        print(user)
    }
}
