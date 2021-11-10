//
//  CompleteProfileView.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import Then
import SnapKit

// MARK: - Style

private extension Style {
    enum CompleteProfileView {
//        static let logoImageSize = CGSize(width: 150, height: 150)
        static let addPhotoButtonSize = CGSize(width: 150, height: 150)
        static let addPhotoButtonTintColor = BaseColors.white
    }
}

class CompleteProfileView: UIView {
    // MARK: - Properties

    lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }

    lazy var addPhotoButton = UIButton(type: .system).then {
        $0.setImage(Asset.plusPhoto.image, for: .normal)
        $0.tintColor = Style.CompleteProfileView.addPhotoButtonTintColor
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }

    // MARK: - Private Properties

//    private lazy var logoImageView = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.clipsToBounds = true
//        $0.image = Asset.Logo.main.image
//    }

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fill
        [
//            logoImageView,
//            emailContainerView,
//            passwordContainerView,
//            signUpButton
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
        addPhotoButton.layer.cornerRadius = Style.CompleteProfileView.addPhotoButtonSize.height / 2
    }

    private func addSubviews() {
        add {
            addPhotoButton
//            logoImageView
//            stack
//            haveAccountButton
        }
    }

    private func makeConstraints() {
//        logoImageView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide)
//            make.centerX.equalTo(self)
//            make.size.equalTo(Style.RegistrationView.logoImageSize)
//        }
//
//        stack.snp.makeConstraints { make in
//            make.top.equalTo(logoImageView.snp.bottom).offset(Style.Spacers.space2)
//            make.left.equalTo(Style.Spacers.space2)
//            make.right.equalTo(-Style.Spacers.space2)
//        }


        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.size.equalTo(Style.CompleteProfileView.addPhotoButtonSize)
        }
//
//        stack.snp.makeConstraints { make in
//            make.top.equalTo(addPhotoButton.snp.bottom).offset(Style.Spacers.space2)
//            make.left.equalTo(Style.Spacers.space2)
//            make.right.equalTo(-Style.Spacers.space2)
//        }

//        haveAccountButton.snp.makeConstraints { make in
//            make.bottom.equalTo(safeAreaLayoutGuide)
//            make.centerX.equalTo(self)
//        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct CompleteProfileViewPreview: PreviewProvider {
    static var previews: some View {
        CompleteProfileView().embedForPreview()
    }
}
