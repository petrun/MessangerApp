//
//  RequiredRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

class RequiredRule: Rule {
    var message: String

    init(message: String = "This field is required") {
        self.message = message
    }

    func validate(_ value: String) -> Bool {
        !value.isEmpty
    }
}
