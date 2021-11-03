//
//  MinLengthRule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

class MinLengthRule: Rule {
    private var minLength: Int
    var message: String

    init(length: Int, message: String = "Must be at least %ld characters long") {
        self.minLength = length
        self.message = String(format: message, self.minLength)
    }

    func validate(_ value: String) -> Bool { value.count >= minLength }
}
