//
//  ValidatorDictionary.swift
//  MessangerApp
//
//  Created by andy on 04.11.2021.
//

import Foundation

struct ValidatorDictionary<T>: Sequence {
    private var innerDictionary: [ObjectIdentifier: T] = [:]

    subscript(key: ValidatableField?) -> T? {
        get {
            if let key = key {
                return innerDictionary[ObjectIdentifier(key)]
            } else {
                return nil
            }
        }
        set(newValue) {
            if let key = key {
                innerDictionary[ObjectIdentifier(key)] = newValue
            }
        }
    }

//    mutating func removeAll() {
//        innerDictionary.removeAll()
//    }

//    mutating func removeValueForKey(_ key: ValidatableField) {
//        innerDictionary.removeValue(forKey: ObjectIdentifier(key))
//    }

    var isEmpty: Bool { innerDictionary.isEmpty }

    func makeIterator() -> DictionaryIterator<ObjectIdentifier, T> {
        innerDictionary.makeIterator()
    }
}
