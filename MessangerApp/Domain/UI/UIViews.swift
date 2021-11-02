import Then
import SnapKit

private extension Style {
    struct ContainerFromImageView {
        let theme: Theme
        let imageSize = CGSize(width: 24, height: 24)
        let height = 50
        var dividerBackgroundColor: UIColor { BaseColors.white }
        let dividerHeight = 0.75
    }
}

extension UIView {
    convenience init(containerFrom image: UIImage, textField: UITextField, theme: Theme) {
        self.init()

        let style = Style.ContainerFromImageView(theme: theme)

        let imageView = UIImageView(image: image)
        let dividerView = UIView().then {
            $0.backgroundColor = style.dividerBackgroundColor
        }

        // Add Subviews
        add {
            imageView
            textField
            dividerView
        }

        // Make Constraints
        snp.makeConstraints { make in
            make.height.equalTo(style.height)
        }

        imageView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).offset(-Style.Spacers.space1)
            make.size.equalTo(style.imageSize)
        }

        textField.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Style.Spacers.space1)
            make.bottom.equalTo(self).offset(-Style.Spacers.space1)
            make.right.equalTo(self)
        }

        dividerView.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.bottom.equalTo(self)
            make.right.equalTo(textField)
            make.height.equalTo(style.dividerHeight)
        }
    }
}
