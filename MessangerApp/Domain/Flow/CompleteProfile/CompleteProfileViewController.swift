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
    private lazy var validator = Validator()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.addPhotoContainer.imagePicker.delegate = self

        initValidator()
        addTargets()
    }

    // MARK: - Private Methods

    private func addTargets() {
        mainView.addPhotoContainer.addPhotoButton.addTarget(
            self,
            action: #selector(handleAddProfilePhoto),
            for: .touchUpInside
        )
        mainView.submitButton.addTarget(self, action: #selector(handleSubmitForm), for: .touchUpInside)
    }

    private func initValidator() {
        validator.styleTransformers(
            success: ValidatorStyleTransformers.success,
            error: ValidatorStyleTransformers.error
        )

        validator.registerField(
            mainView.nameTextField,
            errorLabel: mainView.nameContainerView.errorLabel,
            rules: [RequiredRule(), MinLengthRule(length: 5)])
    }

    // MARK: - Selectors

    @objc private func handleSubmitForm() {
        validator.validate(self)
    }

    @objc private func handleAddProfilePhoto() {
        present(mainView.addPhotoContainer.imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CompleteProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        profileImage = image

        mainView.addPhotoContainer.setImage(image.withRenderingMode(.alwaysOriginal))

        dismiss(animated: true)
    }
}

// MARK: - ValidationDelegate
extension CompleteProfileViewController: ValidationDelegate {
    func validationSuccessful() {
        guard
            let name = mainView.nameTextField.text
        else {
            return
        }

        viewModel.createProfile(image: profileImage, name: name)
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation FAILED!")
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
