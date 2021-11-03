//
//  Rule.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

protocol Rule {
    var message: String { get set }

    func validate(_ value: String) -> Bool
    func errorMessage() -> String
}

extension Rule {
    func errorMessage() -> String { message }
}
