//
//  CompleteProfileViewController.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import UIKit

class CompleteProfileViewController: ViewController<CompleteProfileView> {
    // MARK: - Properties

    var viewModel: CompleteProfileViewModelProtocol!

    // MARK: - Private Properties

    private var profileImage: UIImage?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.imagePicker.delegate = self

        addTargets()
    }

    // MARK: - Private Methods

    private func addTargets() {
        mainView.addPhotoButton.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
//        mainView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        mainView.haveAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    }

    // MARK: - Selectors

//    @objc func handleShowLogin() {
//        viewModel.handleShowLogin()
//    }

//    @objc func handleSignUp() {
//        let validator = Validator()
//
//        validator.registerField(
//            mainView.emailTextField,
//            errorLabel: mainView.emailContainerView.errorLabel,
//            rules: [RequiredRule(), EmailRule()])
//
//        validator.registerField(
//            mainView.passwordTextField,
//            errorLabel: mainView.passwordContainerView.errorLabel,
//            rules: [RequiredRule(), MinLengthRule(length: 5)])
//
//        validator.validate(self)
//    }

    @objc func handleAddProfilePhoto() {
        present(mainView.imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CompleteProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        profileImage = image

        mainView.addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)

        mainView.addPhotoButton.layer.borderColor = UIColor.white.cgColor
        mainView.addPhotoButton.layer.borderWidth = 3

        dismiss(animated: true)
    }
}

// extension CompleteProfileViewController: ValidationDelegate {
//    func validationSuccessful() {
//        print("validationSuccessful")
////        guard let profileImage = profileImage else {
////            print("DEBUG: Please select a profile image...")
////            return
////        }
//
//        guard
//            let email = mainView.emailTextField.text,
//            let password = mainView.passwordTextField.text
////            let fullname = mainView.fullnameTextField.text,
////            let username = mainView.usernameTextField.text?.lowercased(),
////            let imageData = profileImage.jpegData(compressionQuality: 0.3)
//        else {
//            return
//        }
//
//        viewModel.handleSignUp(
//            email: email,
//            password: password
////            fullname: fullname,
////            username: username,
////            imageData: imageData
//        )
//    }
//
//    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
//        for (field, error) in errors {
//            if let field = field as? UITextField {
//                field.layer.borderColor = UIColor.red.cgColor
//                field.layer.borderWidth = 1
//            }
//            error.errorLabel?.text = error.errorMessage // works if you added labels
//            error.errorLabel?.isHidden = false
//        }
//    }
// }
