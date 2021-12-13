//
//  CompleteProfileViewModel.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import UIKit

protocol CompleteProfileViewModelProtocol {
    func createProfile(image: UIImage?, name: String)
}

final class CompleteProfileViewModel {
    var coordinatorHandler: CompleteProfileCoordinatorDelegate?

    private let uid: String
    private let editProfileHandler: EditProfileHandlerProtocol

    init(uid: String, editProfileHandler: EditProfileHandlerProtocol) {
        self.uid = uid
        self.editProfileHandler = editProfileHandler
    }

    deinit {
        print("DEINIT CompleteProfileViewModel")
    }
}

extension CompleteProfileViewModel: CompleteProfileViewModelProtocol {
    func createProfile(image: UIImage?, name: String) {
        editProfileHandler.createProfile(uid: uid, image: image, name: name) { [weak self] error in
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self?.coordinatorHandler?.showMainPage()

            print("Complete create profile")
        }
    }
}
