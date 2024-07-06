//
// Created by Rene Dohan on 2019-01-21.
//

import Foundation

public extension NSString {
    static let newLine = "\n"
    static let notFound = -1

    func index(of string: String, from index: Int) -> Int {
        if index > length - 1 { return NSString.notFound }
        let _range = range(of: string, range: NSRange(location: index, length: length - index))
        if _range.length == 0 { return NSString.notFound }
        return _range.location
    }

    func substring(from: Int, to: Int) -> String {
        let substringLength = to - from
        return substring(with: NSRange(location: from,
                                       length: substringLength < length ? substringLength : length))
    }
}
