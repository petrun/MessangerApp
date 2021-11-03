//
//  Validatable.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import UIKit

typealias ValidatableField = AnyObject & Validatable

protocol Validatable {
    var validationText: String { get }
}

extension UITextField: Validatable {
    var validationText: String { text ?? "" }
}

extension UITextView: Validatable {
    var validationText: String { text ?? "" }
}
