//
//  Log.swift
//  MessangerApp
//
//  Created by andy on 28.10.2021.
//

import Foundation
import os.log

final class Log {
    static func error(_ message: String) {
        os_log("%@", log: .default, type: .error, message)
    }

    static func debug(_ message: String) {
        os_log("%@", log: .default, type: .debug, message)
    }
}
