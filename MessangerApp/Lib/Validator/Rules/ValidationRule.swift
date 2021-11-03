//
//  ValidationRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import UIKit

class ValidationRule {
    var field: ValidatableField
    var errorLabel: UILabel?
    var rules: [Rule] = []

    init(field: ValidatableField, rules: [Rule], errorLabel: UILabel?) {
        self.field = field
        self.errorLabel = errorLabel
        self.rules = rules
    }

    func validateField() -> ValidationError? {
        return rules
            .filter { !$0.validate(field.validationText) }
            .map { ValidationError(field: self.field, errorLabel: self.errorLabel, error: $0.errorMessage()) }
            .first
    }
}
