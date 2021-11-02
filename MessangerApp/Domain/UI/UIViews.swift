import Then
import SnapKit

extension UIView {
    convenience init(containerFrom image: UIImage, textField: UITextField) {
        self.init()

        let imageView = UIImageView(image: image)
        let dividerView = UIView().then {
            $0.backgroundColor = Style.Views.ContainerFrom.dividerBackgroundColor
        }

        // Add Subviews
        add {
            imageView
            textField
            dividerView
        }

        // Make Constraints
        snp.makeConstraints { make in
            make.height.equalTo(Style.Views.ContainerFrom.height)
        }

        imageView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).offset(-Style.Spacers.space1)
            make.size.equalTo(Style.Views.ContainerFrom.imageSize)
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
            make.height.equalTo(Style.Views.ContainerFrom.dividerHeight)
        }
    }
}
