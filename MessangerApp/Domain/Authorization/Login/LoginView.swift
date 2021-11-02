//
//  LoginView.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import SnapKit
import UIKit

// MARK: - Style

private extension Style {
    enum LoginView {
        static let logoImageSize = CGSize(width: 150, height: 150)
    }
}

class LoginView: UIView {
    // MARK: - Properties

    lazy var emailTextField = UITextField(withPlaceholder: L10n.emailPlaceholder)

    lazy var passwordTextField = UITextField(withPlaceholder: L10n.passwordLabel).then {
        $0.isSecureTextEntry = true
    }

    lazy var dontHaveAccountButton = UIButton(first: L10n.dontHaveAnAccountQuestionTitle, second: L10n.signUpTitle)

    lazy var loginButton = UIButton(submitTitle: L10n.loginTitle)

    // MARK: - Private Properties

    private lazy var logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = Asset.twitterLogoWhite.image
    }

    private lazy var emailContainerView = UIView(
        containerFrom: Asset.iconEmailOutletWhite.image,
        textField: emailTextField
    )

    private lazy var passwordContainerView = UIView(
        containerFrom: Asset.iconLockOutletWhite.image,
        textField: passwordTextField
    )

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fillEqually
        [
            emailContainerView,
            passwordContainerView,
            loginButton
        ].forEach { stack.addArrangedSubview($0) }
    }

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
    }

    private func addSubviews() {
        add {
            logoImageView
            stack
            dontHaveAccountButton
        }
    }

    private func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.size.equalTo(Style.LoginView.logoImageSize)
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Style.Spacers.space2)
            make.left.equalTo(Style.Spacers.space2)
            make.right.equalTo(-Style.Spacers.space2)
        }

        dontHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginView().embedForPreview()
    }
}
