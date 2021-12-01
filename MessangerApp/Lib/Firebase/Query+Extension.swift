//
//  Query+Extension.swift
//  MessangerApp
//
//  Created by andy on 30.11.2021.
//

import FirebaseFirestore

extension Query {
    // Фильтрация по префиксу
    func filterBy(field: String, prefix: String) -> Query {
        whereField("name", isGreaterThanOrEqualTo: prefix)
        .whereField("name", isLessThan: "\(prefix)\u{F7FF}")
    }
}
