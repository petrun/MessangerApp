//
//  ValidationError.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import UIKit

class ValidationError: NSObject {
    let field: ValidatableField
    var errorLabel: UILabel?
    let errorMessage: String

    init(field: ValidatableField, errorLabel: UILabel?, error: String) {
        self.field = field
        self.errorLabel = errorLabel
        self.errorMessage = error
    }
}
