//
//  ProfileViewModel.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import UIKit

struct EditProfileData {
    let image: UIImage?
    let name: String
}

protocol EditProfileViewModelProtocol {
    func backButtonPressed()
    func updateProfile(data: EditProfileData)
}

class EditProfileViewModel {
    var coordinatorHandler: EditProfileCoordinatorDelegate?

    private let user: User
    private let updateProfileHandler: UpdateProfileHandlerProtocol

    init(user: User, updateProfileHandler: UpdateProfileHandlerProtocol) {
        self.user = user
        self.updateProfileHandler = updateProfileHandler
        print(user)
    }
}

extension EditProfileViewModel: EditProfileViewModelProtocol {
    func backButtonPressed() {
        coordinatorHandler?.dismiss()
        print("tapBackButton")
    }

    func updateProfile(data: EditProfileData) {
        print("tapDoneButton")

        updateProfileHandler.updateProfile(
            uid: user.uid,
            image: data.image,
            name: data.name
        ) { [weak self] error in
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self?.coordinatorHandler?.dismiss()
        }
    }
}
