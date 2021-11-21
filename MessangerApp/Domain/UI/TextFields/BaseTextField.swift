//
//  BaseTextField.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import SnapKit

private extension Style {
    struct BaseTextField {
        var color: UIColor { Style.textColor }
        var font: UIFont { Fonts.body }
        var textFieldBackgroundColor: UIColor { .tertiarySystemFill }
        let height = 44
        var leftPadding: CGFloat { 15 }
        var rightPadding: CGFloat { 15 }
        var cornerRadius: CGFloat { 8 }
    }
}

class BaseTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let style = Style.BaseTextField()

        backgroundColor = style.textFieldBackgroundColor
        setLeftPaddingPoints(style.leftPadding)
        setRightPaddingPoints(style.rightPadding)
        layer.cornerRadius = style.cornerRadius

        textColor = style.color
        font = style.font

        snp.makeConstraints { make in
            make.height.equalTo(style.height)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
