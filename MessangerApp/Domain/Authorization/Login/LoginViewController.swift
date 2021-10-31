import Foundation

class LoginViewController: ViewController<LoginView> {
    // MARK: - Properties

    var viewModel: LoginViewModelProtocol!

    // MARK: - Private Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        addTargets()
    }

    // MARK: - Private Methods

    private func setupStyle() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    private func addTargets() {
        mainView.dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        mainView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc func handleLogin() {
        guard let email = mainView.emailTextField.text, let password = mainView.passwordTextField.text else {
            print("Empty login or password")
            return
        }

        viewModel.handleLogin(email: email, password: password)
    }

    @objc func handleShowSignUp() {
        viewModel.handleShowSignUp()
    }
}
