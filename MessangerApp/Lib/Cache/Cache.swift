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
    private var storage = NSCache<NSString, AnyObject>()

    func get(key: String) -> Any? {
        storage.object(forKey: key as NSString)
    }

    func set(key: String, data: Any) {
        storage.setObject(data as AnyObject, forKey: key as NSString)
    }
}
