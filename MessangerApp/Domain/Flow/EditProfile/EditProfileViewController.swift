//
//  ProfileViewController.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import UIKit

class EditProfileViewController: ViewController<EditProfileView> {
    // MARK: - Properties

    var viewModel: EditProfileViewModelProtocol!

    // MARK: - Private Properties

    private var profileImage: UIImage?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray5
        title = "Edit profile"

        mainView.imagePicker.delegate = self

        addTargets()
        configureLeftBarButton()
        configureRightBarButton()
    }

    // MARK: - Private Methods

    private func addTargets() {
        mainView.addPhotoButton.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
    }

    private func configureLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
    }

    private func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonPressed)
        )
    }

    // MARK: - Actions

    @objc private func backButtonPressed() {
        viewModel.backButtonPressed()
    }

    @objc private func doneButtonPressed() {
        print("Touch doneButton")
        guard let name = mainView.nameTextField.text else {
            showAlert(title: "Error", message: "Name is empty")
            return
        }
        viewModel.updateProfile(data: EditProfileData(image: profileImage, name: name))
    }

    @objc func handleAddProfilePhoto() {
        present(mainView.imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        profileImage = image

        mainView.addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)

        mainView.addPhotoButton.layer.borderColor = UIColor.white.cgColor
        mainView.addPhotoButton.layer.borderWidth = 3

        dismiss(animated: true)
    }
}
