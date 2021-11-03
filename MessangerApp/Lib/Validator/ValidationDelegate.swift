//
//  ValidationDelegate.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

protocol ValidationDelegate: AnyObject {
    func validationSuccessful()
    func validationFailed(_ errors: [(Validatable, ValidationError)])
}
