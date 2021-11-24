//
//  AlertService.swift
//  MessangerApp
//
//  Created by andy on 06.11.2021.
//

import UIKit

// TODO Refactoring
class AlertService {
    static func showAlert(
        style: UIAlertController.Style,
        title: String?,
        message: String?,
        actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }

        UIApplication.shared
            .delegate?.window??.rootViewController?
            .present(alert, animated: true, completion: completion)
    }
}
