//
//  UITextField+Extension.swift
//  MessangerApp
//
//  Created by andy on 09.11.2021.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        self.rightViewMode = .always
    }
}
