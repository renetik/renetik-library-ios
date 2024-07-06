//
// Created by Rene Dohan on 12/16/19.
//

import Foundation

public protocol CSAny {}

public extension CSAny {
    static func cast(_ object: Any) -> Self { object as! Self }

    var notNil: Bool { true }

    var isNil: Bool { false }

    @discardableResult
    func also(_ function: (Self) -> Void) -> Self {
        function(self)
        return self
    }

    @discardableResult
    func invoke(_ function: Func) -> Self {
        function()
        return self
    }

    @discardableResult
    func invoke(from: Int, until: Int, function: (Int) -> Void) -> Self {
        from.until(until, function)
        return self
    }

    @discardableResult
    func run(_ function: Func) {
        function()
    }

    func then(_ function: (Self) -> Void) { function(self) }

    // let in kotlin
    func get<ReturnType>(_ function: (Self) -> ReturnType) -> ReturnType { function(self) }

    var asString: String { "\(self)" }

//    public var description: String { "\(type(of: self))" }

    func cast<T>() -> T { self as! T }

    func castOrNil<T>() -> T? { self as? T }

    func equals(to object: Any?) -> Bool { // TODO: check how this is reliable
        if String(describing: self) == String(describing: object) { return true }
        return false
    }
}

public extension CSAny where Self: NSObject { // TODO: Use custom isEqual
    func equals(one objects: NSObject...) -> Bool {
        if objects.contains(self) { return true }
        return false
    }
}
