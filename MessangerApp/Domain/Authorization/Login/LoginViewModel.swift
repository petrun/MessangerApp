//
//  LoginViewModel.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func handleLogin(email: String, password: String)
    func handleShowSignUp()
}

final class LoginViewModel {
//    private let authService: AuthService
//    private let logger: LoggerProtocol
    var coordinatorDelegate: LoginCoordinatorDelegate?

//    init(authService: AuthService, logger: LoggerProtocol){
//        self.authService = authService
//        self.logger = logger
//    }
}

extension LoginViewModel: LoginViewModelProtocol {
    func handleLogin(email: String, password: String) {
//        authService.login(email: email, password: password) { [weak self] _, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                self.logger.error("Auth error: \(error.localizedDescription)")
//                return
//            }
//
//            self.coordinatorDelegate?.showMainPage()
//        }
    }

    func handleShowSignUp() {
        coordinatorDelegate?.showSignUp()
    }
}
