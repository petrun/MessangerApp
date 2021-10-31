//
//  RegistrationViewModel.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Foundation

protocol RegistrationViewModelProtocol: AnyObject {
    func handleSignUp(
        email: String,
        password: String,
        fullname: String,
        username: String,
        imageData: Data
    )

    func handleShowLogin()
}

final class RegistrationViewModel {
//    private let authService: AuthService
//    private let logger: LoggerProtocol
    var coordinatorDelegate: RegistrationCoordinatorDelegate?

//    init(authService: AuthService, logger: LoggerProtocol) {
//        self.authService = authService
//        self.logger = logger
//    }
}

extension RegistrationViewModel: RegistrationViewModelProtocol {
    func handleSignUp(email: String, password: String, fullname: String, username: String, imageData: Data) {
        print("Call RegistrationViewModel.handleSignUp")

//        authService.registerUser(
//            credentials: AuthCredentials(
//                email: email,
//                password: password,
//                fullname: fullname,
//                username: username,
//                imageData: imageData
//            )
//        ) { [weak self] error, _ in
//            guard let self = self else { return }
//
//            self.logger.info("User register completion ...")
//
//            if let error = error {
//                self.logger.error("Auth error: \(error.localizedDescription)")
//                return
//            }
//
//            self.coordinatorDelegate?.showMainPage()
//        }
    }

    func handleShowLogin() {
        print("Call RegistrationViewModel.handleSignUp")
        coordinatorDelegate?.backToLogin()
    }
}
