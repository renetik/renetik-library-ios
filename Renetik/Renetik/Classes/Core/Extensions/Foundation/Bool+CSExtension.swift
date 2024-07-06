//
// Created by Rene Dohan on 12/29/19.
//

import Foundation

public extension Bool {
    var isTrue: Bool { self == true }
    var isFalse: Bool { self == false }

    @discardableResult
    func then(_ function: Func) -> CSConditionalResult {
        if isTrue { function() }
        return CSConditionalResult(doElseIf: isFalse)
    }

    @discardableResult
    func isTrue(_ function: Func) -> CSConditionalResult {
        if isTrue { function() }
        return CSConditionalResult(doElseIf: isFalse)
    }
}

public extension Optional where Wrapped == Bool {
    var isTrue: Bool { self == true }
    var isFalse: Bool { self == false }
}
