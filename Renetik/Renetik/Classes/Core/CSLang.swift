//
// Created by Rene on 2018-11-22.
// Copyright (c) 2018 Renetik Software. All rights reserved.
//

import Foundation

public typealias Func = () -> Void
public typealias ArgFunc<Argument> = (Argument) -> Void

public let defaultAnimationTime: TimeInterval = 0.25

enum CSError: Error {
    case todo
    case unsupported
    case failed
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) { self.message = message }

    public var localizedDescription: String { message }
}

let isDebug: Bool = {
    var isDebug = false

    func setDebug() -> Bool {
        isDebug = true
        return true
    }

    assert(setDebug())
    return isDebug
}()

let renetikBundle: Bundle = {
//    When use_framewarks! let bundle = Bundle(identifier: "org.cocoapods.Renetik")!
//    When #use_modular_headers! Bundle.main
//    TODO?: How to solve this universally
    let bundle = Bundle(identifier: "org.cocoapods.Renetik")!
    return Bundle(path: bundle.path(forResource: "RenetikBundle", ofType: "bundle")!)!
}()

public func localized(_ key: String) -> String {
    var string = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    if string == key {
        string = renetikBundle.localizedString(forKey: key, value: nil, table: nil)
        if string == key { logWarn("localized key ot found \(key)") }
    }
    return string
}

public func later(seconds _: Int = 0, function: @escaping Func) {
    DispatchQueue.main.async(execute: function)
}

public func later(seconds: Double, function: @escaping Func) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: function)
}

private let userInitiatedQueue = DispatchQueue(label: "CSUserInitiatedQueue", qos: .userInitiated)

private let utilityQueue = DispatchQueue(label: "CSUtilityQueue", qos: .utility)

public func background(function: @escaping Func) {
    userInitiatedQueue.async(execute: function)
}

public func stringify<Subject>(_ value: Subject) -> String {
    if value == nil { return "" }
    return (value as? OptionalProtocol)?.asString ?? String(describing: value)
}

public func describe<Subject>(_ value: Subject) -> String {
    if value == nil { return "nil" }
    return String(describing: value)
}

public func notNil(_ items: Any?...) -> Bool {
    for it in items {
        if it.isNil { return false }
    }
    return true
}

public func isSomeNil(_ items: Any?...) -> Bool { !notNil(items) }

public func when<Type>(notNil item: Type?, then: ArgFunc<Type>) {
    if item.notNil { then(item!) }
}

public func when<Type>(isNil item: Type?, then: Func) {
    if item.isNil { then() }
}

open class CSObject: CSAny, Equatable, CustomStringConvertible {
    public init() {}

    public static func == (lhs: CSObject, rhs: CSObject) -> Bool { lhs === rhs }

    public var description: String { "\(type(of: self))" }
}

public class Nil: CSAny, Equatable {
    private init() {}

    public static var instance: Nil = .init()

    public static func == (_: Nil, _: Nil) -> Bool { true }
}

extension IndexPath: CSAny {}

extension NSObject: CSAny {}

extension String: CSAny {}

extension Int: CSAny {}

extension Float: CSAny {}

extension Double: CSAny {}

extension CGFloat: CSAny {}

extension Array: CSAny {}

extension Dictionary: CSAny {}

func function(if boolean: Bool, function: Func) -> CSConditionalResult {
    if boolean { function() }
    return CSConditionalResult(doElseIf: boolean == false)
}

public class CSConditionalResult {
    let isDoElse: Bool

    public init(doElseIf: Bool) { isDoElse = doElseIf }

    public func elseDo(_ function: Func) { if isDoElse { function() } }
}

func functionTest() {
    let A = "A"
    let B = "B"
    function(if: A == B) {
        let message = "A == B"
        logInfo(message)
    }.elseDo {
        let message = "A != B"
        logInfo(message)
    }
}
