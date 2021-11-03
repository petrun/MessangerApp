//
//  RegexRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

class RegexRule: Rule {
    private var regex: String = "^(?=.*?[A-Z]).{8,}$"
    var message: String

    init(regex: String, message: String = "Invalid Regular Expression") {
        self.regex = regex
        self.message = message
    }

    func validate(_ value: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
    }
}
