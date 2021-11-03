//
//  EmailRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

class EmailRule: RegexRule {
    private static let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    convenience init(message: String = "Must be a valid email address") {
        self.init(regex: EmailRule.regex, message: message)
    }
}
