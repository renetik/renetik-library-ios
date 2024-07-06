//
//  String+CSExtension.swift
//  Renetik
//
//  Created by Rene Dohan on 2/14/19.
//

import Foundation
import RenetikObjc

public extension String {
    static let newLine = "\n"

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in
            letters.randomElement()!
        })
    }

    func jsonValue() -> Any? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .allowFragments])
        }
        return nil
    }

    var isSet: Bool { !isEmpty }

    var trim: String { asNSString.trim() }

    var length: Int { count }

    var asNSString: NSString { self as NSString }

    var boolValue: Bool { asNSString.boolValue }

    var doubleValue: Double { asNSString.doubleValue }

    var intValue: Int { asNSString.integerValue }

    func substring(from index: Int) -> String {
        asNSString.substring(from: index, to: length) as String
    }

    func substring(to index: Int) -> String {
        asNSString.substring(from: 0, to: index) as String
    }

    func substring(from: Int, to: Int) -> String {
        asNSString.substring(from: from, to: to) as String
    }

    @inlinable func stringIndex(at: String.IndexDistance) -> String.Index {
        index(startIndex, offsetBy: at)
    }

    func index(of string: String, from: Int) -> Int? {
        let index = asNSString.index(of: string, from: from)
        return index >= 0 ? index : nil
    }

    func index(of string: String) -> Int? { index(of: string, from: 0) }

    func contains(_ string: String, ignoreCase: Bool = false) -> Bool {
        ignoreCase ? asNSString.containsNoCase(string) : asNSString.contains(string)
    }

    func remove(_ string: String) -> String { remove(all: string) }

    func remove(all string: String) -> String { replace(all: string, with: "") }

    // func remove(first

    func replace(all string: String, with replace: String) -> String {
        replacingOccurrences(of: string, with: replace)
    }

    // func replace(first

    func attributed(_ dictionary: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        NSAttributedString(string: self, attributes: dictionary)
    }

    func split(by separator: String) -> [String] { components(separatedBy: separator) }
}

// public extension String {
//    mutating func insert(_ string: String, index: Int) {
//        insert(contentsOf: string, at: stringIndex(at: index))
//        replace(from: index, to: index, with: string)
//    }

//    mutating func replace(from: Int, to: Int, with replace: String) {
//        replaceSubrange(stringIndex(at: from)..<stringIndex(at: to), with: replace)
//    }
// }

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        if self == nil {
            return true
        }
        return self!.isEmpty
    }

    func isNilOrEmpty(_ function: Func) -> Self {
        if isNilOrEmpty { function() }
        return self
    }

    var isSet: Bool {
        if self == nil {
            return false
        }
        return !self!.isEmpty
    }

    func contains(_ string: String) -> Bool {
        if self == nil {
            return false
        }
        return self!.contains(string)
    }
}
