import SnapKit

private extension Style {
    struct BaseButton {
        let theme: Theme
        var backgroundColor: UIColor { theme.buttonBackgroundColor }
        let borderRadius = CGFloat(5)
        var color: UIColor { theme.buttonTextColor }
        var font: UIFont { Fonts.large }
        let height = CGFloat(50)
    }

    struct LinkButton {
        let theme: Theme
        var color: UIColor { theme.textColor }
        var font: UIFont { Fonts.body }
    }
}

extension UIButton {
    /// Attributed button
    convenience init(first: String, second: String, theme: Theme) {
        self.init(type: .system)

        let style = Style.LinkButton(theme: theme)

        let attributedTitle = NSMutableAttributedString(string: "\(first) ", attributes: [
            NSAttributedString.Key.font: style.font,
            NSAttributedString.Key.foregroundColor: style.color
        ])

        attributedTitle.append(NSAttributedString(string: second, attributes: [
            NSAttributedString.Key.font: style.font,
            NSAttributedString.Key.foregroundColor: style.color
        ]))

        setAttributedTitle(attributedTitle, for: .normal)
    }

    convenience init(submitTitle title: String, theme: Theme) {
        self.init(type: .system)

        let style = Style.BaseButton(theme: theme)

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
