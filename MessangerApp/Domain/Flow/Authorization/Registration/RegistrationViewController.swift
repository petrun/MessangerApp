import UIKit

final class RegistrationViewController: ViewController<RegistrationView> {
    // MARK: - Properties

    var viewModel: RegistrationViewModelProtocol!

    // MARK: - Private Properties

    private lazy var validator = Validator()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initValidator()
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

    private func addTargets() {
        mainView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        mainView.haveAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc func handleShowLogin() {
        viewModel.handleShowLogin()
    }

    @objc func handleSignUp() {
        validator.validate(self)
    }
}

// MARK: - ValidationDelegate
extension RegistrationViewController: ValidationDelegate {
    func validationSuccessful() {
        guard
            let email = mainView.emailTextField.text,
            let password = mainView.passwordTextField.text
        else {
            return
        }

        viewModel.handleSignUp(email: email, password: password)
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
}
