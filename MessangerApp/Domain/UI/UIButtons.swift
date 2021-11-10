import SnapKit

private extension Style {
    struct BaseButton {
        var backgroundColor: UIColor { Style.buttonBackgroundColor }
        let borderRadius = CGFloat(5)
        var color: UIColor { Style.buttonTextColor }
        var font: UIFont { Fonts.large }
        let height = CGFloat(50)
    }

    struct LinkButton {
        var font: UIFont { Fonts.body }
        var firstColor = BaseColors.black
        var secondColor = UIColor(hex: 0x00539F)
    }
}

extension UIButton {
    /// Attributed button
    convenience init(first: String, second: String) {
        self.init(type: .system)

        let style = Style.LinkButton()

        let attributedTitle = NSMutableAttributedString(string: "\(first) ", attributes: [
            NSAttributedString.Key.font: style.font,
            NSAttributedString.Key.foregroundColor: style.firstColor
        ])

        attributedTitle.append(NSAttributedString(string: second, attributes: [
            NSAttributedString.Key.font: style.font,
            NSAttributedString.Key.foregroundColor: style.secondColor
        ]))

        setAttributedTitle(attributedTitle, for: .normal)
    }

    convenience init(submitTitle title: String) {
        self.init(type: .system)

        let style = Style.BaseButton()

        setTitle(title, for: .normal)
        setTitleColor(style.color, for: .normal)
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.borderRadius
        titleLabel?.font = style.font
        snp.makeConstraints { make in
            make.height.equalTo(style.height)
        }
    }
}
