//
//  SafeArray.swift
//  MessangerApp
//
//  Created by andy on 07.12.2021.
//

import Foundation

// @link https://gist.github.com/basememara/afaae5310a6a6b97bdcdbe4c2fdcd0c6
class SafeArray<T> {
    private var array: [T] = []
    private let queue = DispatchQueue(label: "safe_array", attributes: .concurrent)

    init() { }

    convenience init(_ array: [T]) {
        self.init()
        self.array = array
    }
}

extension SafeArray {
    var first: T? {
        var result: T?
        queue.sync { result = self.array.first }
        return result
    }

    var last: T? {
        var result: T?
        self.queue.sync {
            result = self.array.last
        }
        return result
    }

    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }

    var valueArray: [T] {
        var result: [T] = []
        queue.sync {
            result = self.array
        }
        return result
    }
}

extension SafeArray {
    func first(where predicate: (T) -> Bool) -> T? {
        var result: T?
        queue.sync { result = self.array.first(where: predicate) }
        return result
    }

    func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }

    func append(_ elements: [T]) {
        queue.async(flags: .barrier) {
            self.array += elements
        }
    }

    func insert(_ element: T, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }
}
