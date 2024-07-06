//
// Created by Rene Dohan on 12/14/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Foundation
import MaterialComponents
import MaterialComponents.MDCTextInputControllerBase
import Renetik
import RenetikObjc
import UIKit

public extension MDCTextInputControllerBase {
    @discardableResult
    func setError(_ message: String?) -> Self {
        setErrorText(message, errorAccessibilityValue: nil)
        return self
    }

    @discardableResult
    func title(_ value: String) -> Self {
        placeholderText = value
        return self
    }

    @discardableResult
    func width(_ value: CGFloat) -> Self {
        textInput!.width = value
        return self
    }

    @discardableResult
    func keyboard(_ type: UIKeyboardType) -> Self {
        (textInput as! UITextField).keyboardType = type
        return self
    }

    var right: CGFloat { textInput!.right }

    @discardableResult
    func clear() -> Self {
        (textInput as? UITextField)?.clear()
        return self
    }

    @discardableResult
    func text(_ text: String?) -> Self {
        textInput!.text = text
        return self
    }

    @discardableResult
    func left(_ value: CGFloat) -> Self {
        textInput!.from(left: value)
        return self
    }

    @discardableResult
    func noClearButton() -> Self {
        textInput!.clearButtonMode = .never
        return self
    }
}

extension MDCTextInputControllerBase: CSHasTextProtocol, CSHasUIResponder {
    public var responder: UIResponder { textInput! }

    public var text: String {
        get { textInput!.text ?? "" }
        set(value) { textInput!.text = value }
    }
}
