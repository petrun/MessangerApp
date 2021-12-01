//
//  Helpers.swift
//  MessangerApp
//
//  Created by andy on 27.11.2021.
//

import UIKit

func showAlert(
    title: String?,
    message: String?,
    actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],
    completion: (() -> Void)? = nil
) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {
        alert.addAction(action)
    }

    UIApplication.shared
        .delegate?.window??.rootViewController?
        .present(alert, animated: true, completion: completion)
}
