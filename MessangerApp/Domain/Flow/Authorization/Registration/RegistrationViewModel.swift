import Foundation

protocol RegistrationViewModelProtocol: AnyObject {
    func handleSignUp(
        email: String,
        password: String
    )

    func handleShowLogin()
}

final class RegistrationViewModel {
    private let authService: AuthServiceProtocol
    private let logger: LoggerService
    var coordinatorHandler: RegistrationCoordinatorDelegate?

    init(authService: AuthServiceProtocol, logger: LoggerService) {
        self.authService = authService
        self.logger = logger
    }
}

extension RegistrationViewModel: RegistrationViewModelProtocol {
    func handleSignUp(email: String, password: String) {
        logger.info("Call RegistrationViewModel.handleSignUp")

        authService.register(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.coordinatorHandler?.showMainPage()
            case .failure(let error):
                AlertService.showAlert(style: .alert, title: "Error", message: error.localizedDescription)
            }
        }
    }

    func handleShowLogin() {
        print("Call RegistrationViewModel.handleSignUp")
        coordinatorHandler?.backToLogin()
    }
}
