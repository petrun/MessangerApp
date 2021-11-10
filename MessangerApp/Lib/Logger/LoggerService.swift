import Foundation

class LoggerService {
    func verbose(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        fatalError("Need override LoggerService::verbose")
    }

    func debug(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        fatalError("Need override LoggerService::debug")
    }

    func info(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        fatalError("Need override LoggerService::info")
    }

    func warning(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        fatalError("Need override LoggerService::warning")
    }

    func error(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        fatalError("Need override LoggerService::error")
    }
}
