//
//  CSLogger.swift
//  Renetik
//
//  Created by Rene Dohan on 2/10/19.
//

import Foundation

@objc public protocol CSLogger {
    func logDebug(_ value: String)
    func logInfo(_ value: String)
    func logWarn(_ value: String)
    func logError(_ value: String)
}

public extension UIViewController {
    func logInfoToast<Subject>(_ value: Subject, functionName: String = #function,
                               fileName: String = #file, lineNumber: Int = #line)
    {
        let className = fileName.asNSString.lastPathComponent
        logger.logInfo("<\(className)> \(functionName) [#\(lineNumber)]| \(describe(value))")
        toast(describe(value))
    }
}

public func logDebug<Subject>(_ value: Subject, functionName: String = #function,
                              fileName: String = #file, lineNumber: Int = #line)
{
    let className = fileName.asNSString.lastPathComponent
    let message = "<\(className)> \(functionName) [#\(lineNumber)]| \(describe(value))"
    logger.logDebug(message)
    if isDebug { CSNotification(message).time(5).bottom().show() }
}

public func logInfo(functionName: String = #function,
                    fileName: String = #file, lineNumber: Int = #line)
{
    logInfo("", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func logInfo<Subject>(_ value: Subject, functionName: String = #function,
                             fileName: String = #file, lineNumber: Int = #line)
{
    let className = fileName.asNSString.lastPathComponent
    logger.logInfo("<\(className)> \(functionName) [#\(lineNumber)]| \(describe(value))")
}

public func logWarn<Subject>(_ value: Subject, functionName: String = #function,
                             fileName: String = #file, lineNumber: Int = #line)
{
    let className = fileName.asNSString.lastPathComponent
    logger.logWarn("<\(className)> \(functionName) [#\(lineNumber)]| \(describe(value))")
}

public func logError<Subject>(_ value: Subject, functionName: String = #function,
                              fileName: String = #file, lineNumber: Int = #line)
{
    let className = fileName.asNSString.lastPathComponent
    logger.logError("<\(className)> \(functionName) [#\(lineNumber)]| \(describe(value))")
}
