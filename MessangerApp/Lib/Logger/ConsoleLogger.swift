//
//  ConsoleLogger.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation

class ConsoleLogger: LoggerProtocol {
    func error(_ message: String) {
        log("\(getDate()) | ERROR | \(message)")
    }

    func info(_ message: String) {
        log("\(getDate()) | INFO | \(message)")
    }

    func debug(_ message: String) {
        log("\(getDate()) | DEBUG | \(message)")
    }

    private func log(_ message: String) {
        print(message)
    }

    private func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
