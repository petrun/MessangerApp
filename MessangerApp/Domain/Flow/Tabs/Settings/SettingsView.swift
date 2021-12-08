//
//  SettingsView.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Then
import SnapKit

// MARK: - Style

private extension Style {
    enum SettingsView {
        static let logoImageSize = CGSize(width: 150, height: 150)
    }
}

class SettingsView: UIView {
    // MARK: - Properties

    lazy var signUpButton = UIButton(submitTitle: L10n.SignUp.title)

    lazy var haveAccountButton = UIButton(
        first: L10n.IHaveAnAccount.title,
        second: L10n.Login.title
    )

    lazy var emailTextField = BaseTextField().then {
        $0.autocapitalizationType = .none
        $0.placeholder = L10n.Email.placeholder
        $0.textContentType = .emailAddress
    }

    lazy var passwordTextField = BaseTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = L10n.Password.placeholder
    }

    lazy var emailContainerView = InputContainerWithValidation(
        textField: emailTextField
    )

    lazy var passwordContainerView = InputContainerWithValidation(
        textField: passwordTextField
    )

    // MARK: - Private Properties

    private lazy var logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = Asset.Logo.main.image
    }

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fill
        [
            logoImageView,
            emailContainerView,
            passwordContainerView,
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
        backgroundColor = Style.backgroundColor
    }

    private func addSubviews() {
        add {
            logoImageView
            stack
            haveAccountButton
        }
    }

    private func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.size.equalTo(Style.SettingsView.logoImageSize)
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Style.Spacers.space2)
            make.left.equalTo(Style.Spacers.space2)
            make.right.equalTo(-Style.Spacers.space2)
        }

        haveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsView().embedForPreview()
    }
}
