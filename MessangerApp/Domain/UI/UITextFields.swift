import UIKit

extension UITextField {
    convenience init(withPlaceholder placeholder: String) {
        self.init()

        textColor = Style.TextFields.Base.color
        font = Style.TextFields.Base.font
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: Style.TextFields.Base.placeholderColor]
        )
    }
}
