//
// Created by Rene Dohan on 12/22/19.
//

import UIKit

public class CSTextField: UITextField {
    public var hideCursor = false

    override public func caretRect(for position: UITextPosition) -> CGRect {
        hideCursor ? .zero : super.caretRect(for: position)
    }
}
