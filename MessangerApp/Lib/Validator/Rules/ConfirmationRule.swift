//
//  ConfirmationRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

public class ConfirmationRule: Rule {
    private let confirmField: ValidatableField
    var message: String

    init(confirmField: ValidatableField, message: String = "This field does not match") {
        self.confirmField = confirmField
        self.message = message
    }

    func validate(_ value: String) -> Bool { confirmField.validationText == value }
}
