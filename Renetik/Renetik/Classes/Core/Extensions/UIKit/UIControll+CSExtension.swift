//
// Created by Rene Dohan on 1/25/20.
//

import BlocksKit
import RenetikObjc
import UIKit

public extension UIControl {
    @discardableResult
    @objc override open func onClick(_ block: @escaping Func) -> Self {
        onTouchUp(block)
    }

    @discardableResult
    @objc open func onTouchUp(_ block: @escaping Func) -> Self {
        isUserInteractionEnabled = true
        bk_addEventHandler({ _ in block() }, for: .touchUpInside)
        return self
    }

    @discardableResult
    @objc open func onTouchDown(_ block: @escaping Func) -> Self {
        isUserInteractionEnabled = true
        bk_addEventHandler({ _ in block() }, for: .touchDown)
        return self
    }
}
