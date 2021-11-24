//
//  Cache.swift
//  MessangerApp
//
//  Created by andy on 23.11.2021.
//

import Foundation

protocol CacheProtocol {
    func get(key: String) -> Any?
    func set(key: String, data: Any)
}

class Cache: CacheProtocol {
    // TODO: - use NSCache
    private var storage: [String: Any] = [:]

    func get(key: String) -> Any? {
        storage[key]
    }

    func set(key: String, data: Any) {
        storage[key] = data
    }
}
