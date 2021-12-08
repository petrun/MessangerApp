//
//  ValidatorStyleTransformers.swift
//  MessangerApp
//
//  Created by andy on 08.12.2021.
//

import UIKit

struct ValidatorStyleTransformers {
    static var success: ((ValidationRule) -> Void) = { validationRule in
        validationRule.errorLabel?.isHidden = true
        validationRule.errorLabel?.text = ""

        if let textField = validationRule.field as? UITextField {
            textField.layer.borderColor = UIColor.green.cgColor
            textField.layer.borderWidth = 0.5
        } else if let textField = validationRule.field as? UITextView {
            textField.layer.borderColor = UIColor.green.cgColor
            textField.layer.borderWidth = 0.5
        }
    }

    static var error: ((ValidationError) -> Void) = { validationError in
        validationError.errorLabel?.isHidden = false
        validationError.errorLabel?.text = validationError.errorMessage

        if let textField = validationError.field as? UITextField {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        } else if let textField = validationError.field as? UITextView {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
}
