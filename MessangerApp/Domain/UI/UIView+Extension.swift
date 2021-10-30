//
//  UIView+Extension.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Then
import SnapKit
import UIKit

extension UIView {
    static func inputContainerView(image: UIImage, textField: UITextField) -> UIView {
        //Init
        let view = UIView()
        let imageView = UIImageView(image: image)
        let dividerView = UIView().then {
            $0.backgroundColor = .white
        }

        //Add Subviews
        view.add {
            imageView
            textField
            dividerView
        }

        // Make Constraints

        view.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        imageView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.bottom.equalTo(view).offset(-8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        textField.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8)
            make.bottom.equalTo(view).offset(-8)
            make.right.equalTo(view)
        }

        dividerView.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.bottom.equalTo(view)
            make.right.equalTo(textField)
            make.height.equalTo(0.75)
        }

        return view
    }
}
