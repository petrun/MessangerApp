//
//  UITextFields.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Then
import UIKit

extension UITextField {
    static func textField(withPlaceholder placeholder: String) -> UITextField {
        UITextField().then {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 16)
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
        }
    }
}
