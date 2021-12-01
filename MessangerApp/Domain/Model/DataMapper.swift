//
//  DataMapper.swift
//  MessangerApp
//
//  Created by andy on 27.11.2021.
//

import Foundation

protocol DataMapperProtocol {
    associatedtype D // Data
    associatedtype O // Object

    func toObject(data: D, completion: @escaping (O?) -> Void)
    func toData(object: O) -> D
}

class DataMapper<D, O>: DataMapperProtocol {
    func toObject(data: D, completion: @escaping (O?) -> Void) {
        fatalError("Need override DataMapper::toObject")
    }
    func toData(object: O) -> D {
        fatalError("Need override DataMapper::toData")
    }
}
