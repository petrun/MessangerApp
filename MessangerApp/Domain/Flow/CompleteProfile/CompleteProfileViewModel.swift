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
    private let updateProfileHandler: UpdateProfileHandlerProtocol

    init(uid: String, updateProfileHandler: UpdateProfileHandlerProtocol) {
        self.uid = uid
        self.updateProfileHandler = updateProfileHandler
    }

    deinit {
        print("DEINIT CompleteProfileViewModel")
    }
}

extension CompleteProfileViewModel: CompleteProfileViewModelProtocol {
    func createProfile(image: UIImage?, name: String) {
        updateProfileHandler.updateProfile(uid: uid, image: image, name: name) { [weak self] error in
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self?.coordinatorHandler?.showMainPage()

            print("Complete create profile")
        }
    }
}
