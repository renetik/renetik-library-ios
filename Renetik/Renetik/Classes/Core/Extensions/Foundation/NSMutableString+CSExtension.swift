//
// Created by Rene Dohan on 4/13/20.
//

import Foundation

public extension NSMutableString {
    func replace(from: Int, to: Int, with replacement: String) {
        replaceCharacters(in: NSRange(from ..< to), with: replacement)
    }
}
