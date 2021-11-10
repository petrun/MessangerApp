import SwiftyBeaver

class SwiftyBeaverLoggerService: LoggerService {
    init(destinations: [BaseDestination]) {
        destinations.forEach { SwiftyBeaver.addDestination($0) }
    }

    override func verbose(_ message: Any, _ file: String, _ function: String, line: Int, context: Any? = nil) {
        SwiftyBeaver.verbose(message, file, function, line: line, context: context)
    }

    override func debug(_ message: Any, _ file: String, _ function: String, line: Int, context: Any? = nil) {
        SwiftyBeaver.debug(message, file, function, line: line, context: context)
    }

    override func info(_ message: Any, _ file: String, _ function: String, line: Int, context: Any? = nil) {
        SwiftyBeaver.info(message, file, function, line: line, context: context)
    }

    override func warning(_ message: Any, _ file: String, _ function: String, line: Int, context: Any? = nil) {
        SwiftyBeaver.warning(message, file, function, line: line, context: context)
    }

    override func error(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        SwiftyBeaver.error(message, file, function, line: line, context: context)
    }
}
