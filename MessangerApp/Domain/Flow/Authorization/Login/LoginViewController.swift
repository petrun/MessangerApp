import UIKit

class LoginViewController: ViewController<LoginView> {
    // MARK: - Properties

    var viewModel: LoginViewModelProtocol!

    // MARK: - Private Properties

    private lazy var validator = Validator()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initValidator()
        setupStyle()
        addTargets()
    }

    // MARK: - Private Methods

    private func initValidator() {
        validator.styleTransformers(success: { validationRule in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""

            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            } else if let textField = validationRule.field as? UITextView {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            }
        }, error: { validationError in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage

            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            } else if let textField = validationError.field as? UITextView {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })

        validator.registerField(
            mainView.emailTextField,
            errorLabel: mainView.emailContainerView.errorLabel,
            rules: [RequiredRule(), EmailRule()])

        validator.registerField(
            mainView.passwordTextField,
            errorLabel: mainView.passwordContainerView.errorLabel,
            rules: [RequiredRule(), MinLengthRule(length: 6)])
    }

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
        validator.validate(self)
    }

    @objc func handleShowSignUp() {
        viewModel.handleShowSignUp()
    }
}

// MARK: - ValidationDelegate
extension LoginViewController: ValidationDelegate {
    func validationSuccessful() {
        guard let email = mainView.emailTextField.text, let password = mainView.passwordTextField.text else {
            print("Empty login or password")
            return
        }

        viewModel.handleLogin(email: email, password: password)
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
}
