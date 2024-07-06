//
// Created by Rene Dohan on 2019-01-17.
//

import CocoaLumberjack

public class CocoaLumberjackCSLogger: NSObject, CSLogger {
    public func logDebug(_ value: String) {
        DDLogDebug(value)
    }

    public func logInfo(_ value: String) {
        DDLogInfo(value)
    }

    public func logWarn(_ value: String) {
        DDLogWarn(value)
    }

    public func logError(_ value: String) {
        DDLogError(value)
    }
}

public class CSCocoaLumberjackFormatter: NSObject, DDLogFormatter {
    var loggerCount = 0
    let threadUnsafeDateFormatter = DateFormatter().also {
        $0.formatterBehavior = .behavior10_4
        $0.dateFormat = "HH:mm:ss:SSS"
    }

    public func format(message: DDLogMessage) -> String? {
        var logLevel: String
        switch message.flag {
        case DDLogFlag.debug: logLevel = "Debug"
        case DDLogFlag.error: logLevel = "Error"
        case DDLogFlag.warning: logLevel = "Warning"
        case DDLogFlag.info: logLevel = "Info"
        default: logLevel = "Verbose"
        }
        var dateAndTime = threadUnsafeDateFormatter.string(from: message.timestamp)
        return "\(dateAndTime) \(logLevel) \(message.fileName ?? "") \(message.function) \(message.line) = \(message.message)"
    }

    public func didAdd(to _: DDLogger) {
        loggerCount += 1
        assert(loggerCount <= 1, "This logger isn't thread-safe")
    }

    public func willRemove(from _: DDLogger) { loggerCount -= 1 }
}
