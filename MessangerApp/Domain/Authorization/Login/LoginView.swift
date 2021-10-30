//
//  LoginView.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import SnapKit
import UIKit

// MARK: - Appearance

private extension Appearance {
    var animationDuration: Double { 0.1 }
    var parallaxValue: CGFloat { 10 }
    var alphaContainerView: CGFloat { 0.5 }
    var borderColor: UIColor { .gray }
    var customFont: UIFont { .systemFont(ofSize: 14) }
    var buttonCornerRadius: CGFloat { 10 }
}

// MARK: - Constants

private extension Constants {
    static let emailPlaceholder = "Введите e-mail"
    static let textCharatersLimit = 140
}

// MARK: - Grid

private extension Grid {

}
//equalTo(CGSize(width: 50, height: 100))

class LoginView: UIView {

    // MARK: - Properties

    lazy var dontHaveAccountButton = UIButton.attributedButton("Don't have an account?", "Sign Up")
    lazy var loginButton = UIButton.submitButton(title: "Login")

    // MARK: - Private Properties

    private lazy var logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = UIImage(named: "TwitterLogo")
    }

    private lazy var emailTextField = UITextField.textField(withPlaceholder: "Email")

    private lazy var emailContainerView = UIView.inputContainerView(
        image: UIImage(named: "ic_mail_outline_white_2x-1")!,
        textField: emailTextField
    )

    private lazy var passwordTextField = UITextField.textField(withPlaceholder: "Password").then {
        $0.isSecureTextEntry = true
    }

    private lazy var passwordContainerView = UIView.inputContainerView(
        image: UIImage(named: "ic_lock_outline_white_2x")!,
        textField: passwordTextField
    )

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 8
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
        backgroundColor = Constants.twitterBlue
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
            make.size.equalTo(grid.size150)
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(grid.space16)
            make.left.equalTo(grid.space16)
            make.right.equalTo(-grid.space16)
        }

        dontHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
        }
    }
}
