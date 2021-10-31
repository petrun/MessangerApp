//
//  RegistrationViewController.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

final class RegistrationViewController: ViewController<RegistrationView> {
    // MARK: - Properties

    var viewModel: RegistrationViewModelProtocol!

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
        mainView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        mainView.alreadyHaveAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc func handleShowLogin() {
        viewModel.handleShowLogin()
    }

    @objc func handleSignUp() {
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image...")
            return
        }

        guard
            let email = mainView.emailTextField.text,
            let password = mainView.passwordTextField.text,
            let fullname = mainView.fullnameTextField.text,
            let username = mainView.usernameTextField.text?.lowercased(),
            let imageData = profileImage.jpegData(compressionQuality: 0.3)
        else {
            return
        }

        viewModel.handleSignUp(
            email: email,
            password: password,
            fullname: fullname,
            username: username,
            imageData: imageData
        )
    }

    @objc func handleAddProfilePhoto() {
        present(mainView.imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        profileImage = image

        mainView.addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)

        mainView.addPhotoButton.layer.borderColor = UIColor.white.cgColor
        mainView.addPhotoButton.layer.borderWidth = 3

        dismiss(animated: true)
    }
}
