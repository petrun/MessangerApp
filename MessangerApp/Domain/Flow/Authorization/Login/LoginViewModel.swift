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
    private let authService: AuthServiceProtocol
    private let logger: LoggerService
    var coordinatorHandler: LoginCoordinatorDelegate?

    init(authService: AuthServiceProtocol, logger: LoggerService) {
        self.authService = authService
        self.logger = logger
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    func handleLogin(email: String, password: String) {
        authService.login(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.coordinatorHandler?.showMainPage()
            case .failure(let error):
                showAlert(title: L10n.Error.title, message: error.localizedDescription)
            }
        }
    }

    func handleShowSignUp() {
        coordinatorHandler?.showSignUp()
    }
}
