import SnapKit

extension UIButton {
    /// Attributed button
    convenience init(first: String, second: String) {
        self.init(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "\(first) ", attributes: [
            NSAttributedString.Key.font: Style.Buttons.LinkButton.font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])

        attributedTitle.append(NSAttributedString(string: second, attributes: [
            NSAttributedString.Key.font: Style.Buttons.LinkButton.font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))

        setAttributedTitle(attributedTitle, for: .normal)
    }

    convenience init(submitTitle title: String) {
        self.init(type: .system)

        setTitle(title, for: .normal)
        setTitleColor(Style.Buttons.BaseButton.color, for: .normal)
        backgroundColor = Style.Buttons.BaseButton.backgroundColor
        layer.cornerRadius = Style.Buttons.BaseButton.borderRadius
        titleLabel?.font = Style.Buttons.BaseButton.font
        snp.makeConstraints { make in
            make.height.equalTo(Style.Buttons.BaseButton.height)
        }
    }
}
