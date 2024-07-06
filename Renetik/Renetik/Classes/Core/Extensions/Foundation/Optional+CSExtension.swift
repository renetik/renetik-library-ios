//
// Created by Rene Dohan on 12/16/19.
//

import Foundation

public protocol OptionalProtocol {
    var asString: String { get }
}

extension Optional: OptionalProtocol, CSAny {
    public var asString: String {
        if self == nil { return "" } else { return "\(self!)" }
    }
}

public extension Optional {
    var notNil: Bool { self != nil }

    var isNil: Bool { self == nil }

    @discardableResult
    func notNil(_ function: (Wrapped) -> Void) -> CSConditionalResult {
        if self != nil {
            function(self!)
            return CSConditionalResult(doElseIf: false)
        }
        return CSConditionalResult(doElseIf: true)
    }

    @discardableResult
    func isNil(_ function: Func) -> CSConditionalResultNotNil<Wrapped> {
        if self == nil {
            function()
            return CSConditionalResultNotNil()
        }
        return CSConditionalResultNotNil(variable: self!)
    }

    func then<ReturnType>(_ function: (Wrapped) -> ReturnType) -> ReturnType? {
        if self != nil { return function(self!) } else { return nil }
    }

    func equals(to object: Any?) -> Bool { // TODO: check how this is reliable
        if String(describing: self) == String(describing: object) { return true }
        return false
    }
}

public extension Optional where Wrapped: NSObject { // TODO: Use custom isEqual
    func equals(one objects: NSObject...) -> Bool {
        if notNil { if objects.contains(self!) { return true } }
        return false
    }
}

public class CSConditionalResultNotNil<Type> {
    let variable: Type?
    let notNil: Bool

    init() {
        notNil = false
        variable = nil
    }

    init(variable: Type) {
        notNil = true
        self.variable = variable
    }

    public func elseDo(_ function: (Type) -> Void) { if notNil { function(variable!) } }
}
