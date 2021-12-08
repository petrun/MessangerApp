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
        static let addPhotoButtonSize = CGSize(width: 150, height: 150)
        static let addPhotoButtonTintColor = BaseColors.blue
        static let titleLabelTextColor = BaseColors.black
    }
}

class CompleteProfileView: UIView {
    // MARK: - Properties

    lazy var addPhotoContainer = AddPhotoContainer()

    lazy var nameTextField = BaseTextField().then {
        $0.autocapitalizationType = .none
        $0.placeholder = "Name"
    }

    lazy var nameContainerView = InputContainerWithValidation(
        textField: nameTextField
    )

    lazy var submitButton = UIButton(submitTitle: "Submit")

    // MARK: - Private Properties

    private lazy var style = Style.CompleteProfileView.self

    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "Complete profile"
        $0.textColor = style.titleLabelTextColor
        $0.font = Style.Fonts.headingTwo
    }

    private lazy var stack = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = Style.Spacers.space1
        stack.distribution = .fill
        [
            titleLabel,
            addPhotoContainer,
            nameContainerView,
            submitButton
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
            stack
        }
    }

    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Style.Spacers.space2)
            make.left.equalTo(Style.Spacers.space2)
            make.right.equalTo(-Style.Spacers.space2)
        }
    }
}

import SwiftUI

@available(iOS 13, *)
struct CompleteProfileViewPreview: PreviewProvider {
    static var previews: some View {
        CompleteProfileView().embedForPreview()
    }
}
