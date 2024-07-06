//
// Created by Rene Dohan on 12/23/19.
//

import Foundation
import UIKit

public extension UITextInput {
    var text: String {
        get {
            textRange(from: beginningOfDocument, to: endOfDocument)?.get { range in
                text(in: range) ?? ""
            } ?? ""
        }
        set(value) {
            textRange(from: beginningOfDocument, to: endOfDocument)?.get { range in
                replace(range, withText: value)
            }
        }
    }
}
