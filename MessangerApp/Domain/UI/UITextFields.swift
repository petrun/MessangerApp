import UIKit

private extension Style {
    struct BaseTextFields {
        let theme: Theme
        var color: UIColor { theme.textColor }
        var font: UIFont { Fonts.body }
        var placeholderColor: UIColor { theme.textColor }
    }
}

extension UITextField {
    convenience init(withPlaceholder placeholder: String, theme: Theme) {
        self.init()

        let style = Style.BaseTextFields(theme: theme)

        textColor = style.color
        font = style.font
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: style.placeholderColor]
        )
    }
}
