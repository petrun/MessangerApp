//
//  UIAlertController+Extension.swift
//  MessangerApp
//
//  Created by andy on 22.11.2021.
//

import UIKit

extension UIAlertController {
    func addAction(title: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: .default, handler: handler))
    }

    func addCancelAction(title: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: .cancel, handler: handler))
    }
}
