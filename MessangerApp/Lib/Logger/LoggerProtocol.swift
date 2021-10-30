//
//  LoggerProtocol.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation

protocol LoggerProtocol: AnyObject {
    func error(_ message: String)
    func info(_ message: String)
    func debug(_ message: String)
}
