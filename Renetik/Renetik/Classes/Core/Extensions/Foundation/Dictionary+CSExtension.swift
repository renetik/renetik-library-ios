//
// Created by Rene Dohan on 1/24/20.
//

import Foundation

public extension Dictionary {
    @discardableResult
    mutating func add(_ other: Dictionary) -> Dictionary {
        other.forEach { k, v in self[k] = v }
        return self
    }

    @discardableResult
    mutating func remove(key: Key) -> Value? {
        removeValue(forKey: key)
    }

    var asJson: String? {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) {
            return String(data: theJSONData, encoding: .ascii)
        }
        return nil
    }
}
