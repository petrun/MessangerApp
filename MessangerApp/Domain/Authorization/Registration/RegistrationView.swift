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
        static let logoImageSize = CGSize(width: 24, height: 24)
    }
}

class RegistrationView: UIView {
    // MARK: - Properties

    lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }

    lazy var addPhotoButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "plus_photo"), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }

    lazy var signUpButton = UIButton(submitTitle: "Sign Up")

    lazy var alreadyHaveAccountButton = UIButton(first: "Already have an account?", second: "Login")

    lazy var emailTextField = UITextField(withPlaceholder: "Email")

    lazy var passwordTextField = UITextField(withPlaceholder: "Password").then {
        $0.isSecureTextEntry = true
    }

    lazy var fullnameTextField = UITextField(withPlaceholder: "Full Name")

    lazy var usernameTextField = UITextField(withPlaceholder: "Username")

    // MARK: - Private Properties

    private lazy var emailContainerView = UIView(
        containerFrom: UIImage(named: "ic_mail_outline_white_2x-1")!,
        textField: emailTextField
    )

    private lazy var passwordContainerView = UIView(
        containerFrom: UIImage(named: "ic_lock_outline_white_2x")!,
        textField: passwordTextField
    )

    private lazy var fullnameContainerView = UIView(
        containerFrom: UIImage(named: "ic_person_outline_white_2x")!,
        textField: fullnameTextField
    )

    private lazy var usernameContainerView = UIView(
        containerFrom: UIImage(named: "ic_person_outline_white_2x")!,
        textField: usernameTextField
    )

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 8
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
        addPhotoButton.layer.cornerRadius = 150 / 2
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
            make.size.equalTo(Style.RegistrationView.logoImageSize)
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
