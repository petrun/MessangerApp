//
//  RegistrationView.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Then
import SnapKit

// MARK: - Style

private extension Style {
    enum RegistrationView {
        static let addPhotoButtonSize = CGSize(width: 150, height: 150)
        static let addPhotoButtonTintColor = Style.BaseColors.white
    }
}

class RegistrationView: UIView {
    // MARK: - Properties

    lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }

    lazy var addPhotoButton = UIButton(type: .system).then {
        $0.setImage(Asset.plusPhoto.image, for: .normal)
        $0.tintColor = Style.RegistrationView.addPhotoButtonTintColor
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }

    lazy var signUpButton = UIButton(submitTitle: L10n.SignUp.title)

    lazy var alreadyHaveAccountButton = UIButton(
        first: L10n.AlreadyHaveAnAccountQuestion.title,
        second: L10n.Login.title
    )

    lazy var emailTextField = UITextField(withPlaceholder: L10n.Email.placeholder)

    lazy var passwordTextField = UITextField(withPlaceholder: L10n.Password.placeholder).then {
        $0.isSecureTextEntry = true
    }

    lazy var fullnameTextField = UITextField(withPlaceholder: L10n.FullName.placeholder)

    lazy var usernameTextField = UITextField(withPlaceholder: L10n.Username.placeholder)

    // MARK: - Private Properties

    private lazy var emailContainerView = UIView(
        containerFrom: Asset.iconEmailOutletWhite.image,
        textField: emailTextField
    )

    private lazy var passwordContainerView = UIView(
        containerFrom: Asset.iconLockOutletWhite.image,
        textField: passwordTextField
    )

    private lazy var fullnameContainerView = UIView(
        containerFrom: Asset.iconPersonOutletWhite.image,
        textField: fullnameTextField
    )

    private lazy var usernameContainerView = UIView(
        containerFrom: Asset.iconPersonOutletWhite.image,
        textField: usernameTextField
    )

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fillEqually
        [
            emailContainerView,
            passwordContainerView,
            fullnameContainerView,
            usernameContainerView,
            signUpButton
        ].forEach { stack.addArrangedSubview($0) }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        setupStyle()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupStyle() {
        backgroundColor = Style.Colors.secondaryBG
        addPhotoButton.layer.cornerRadius = Style.RegistrationView.addPhotoButtonSize.height / 2
    }

    private func addSubviews() {
        add {
            addPhotoButton
            stack
            alreadyHaveAccountButton
        }
    }

    private func makeConstraints() {
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.size.equalTo(Style.RegistrationView.addPhotoButtonSize)
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(Style.Spacers.space2)
            make.left.equalTo(Style.Spacers.space2)
            make.right.equalTo(-Style.Spacers.space2)
        }

        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct RegistrationViewPreview: PreviewProvider {
    static var previews: some View {
        RegistrationView().embedForPreview()
    }
}
