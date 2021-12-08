//
//  ProfileView.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import Then
import SnapKit

// MARK: - Style

private extension Style {
    enum EditProfileView {
        static let addPhotoButtonSize = CGSize(width: 150, height: 150)
        static let addPhotoButtonTintColor = BaseColors.white
    }
}

class EditProfileView: UIView {
    // MARK: - Properties

    lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }

    lazy var addPhotoButton = UIButton(type: .system).then {
        $0.setImage(Asset.plusPhoto.image, for: .normal)
        $0.tintColor = style.addPhotoButtonTintColor
        $0.imageView?.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }

    lazy var nameTextField = BaseTextField().then {
        $0.autocapitalizationType = .none
        $0.placeholder = "Name"
    }

    lazy var nameContainerView = InputContainerWithValidation(
        textField: nameTextField
    )

    // MARK: - Private Properties

    private lazy var style = Style.EditProfileView.self

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fill
        [
            nameContainerView
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
        addPhotoButton.layer.cornerRadius = style.addPhotoButtonSize.height / 2
    }

    private func addSubviews() {
        add {
            addPhotoButton
            stack
        }
    }

    private func makeConstraints() {
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(self)
            make.size.equalTo(style.addPhotoButtonSize)
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(Style.Spacers.space2)
            make.left.equalTo(Style.Spacers.space2)
            make.right.equalTo(-Style.Spacers.space2)
        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        EditProfileView().embedForPreview()
    }
}
