//
//  CSMaterial+Extensions.swift
//  Motorkari
//
//  Created by Rene Dohan on 3/18/19.
//  Copyright © 2019 Renetik Software. All rights reserved.
//

import Foundation
import MaterialComponents
import Renetik
import RenetikObjc
import UIKit

open class CSMaterialButton: UIButton {
    lazy var inkTouchController = MDCRippleTouchController()

    @discardableResult
    @objc override open func onTouchUp(_ block: @escaping Func) -> Self {
        super.onTouchUp(block)
        inkTouchController.addRipple(to: self)
        return self
    }
}

open class CSMaterialCard: MDCCard {}

open class CSMaterialImageView: UIImageView {
    lazy var inkTouchController = MDCRippleTouchController()

    @discardableResult
    @objc override open func onClick(_ block: @escaping Func) -> Self {
        super.onClick(block)
        inkTouchController.addRipple(to: self)
        return self
    }
}

open class CSMaterialLabel: UILabel {
    lazy var inkTouchController = MDCRippleTouchController()

    @discardableResult
    @objc override open func onClick(_ block: @escaping Func) -> Self {
        super.onClick(block)
        inkTouchController.addRipple(to: self)
        return self
    }
}

open class CSMaterialView: CSView {
    lazy var inkTouchController = MDCRippleTouchController()

    @discardableResult
    @objc override open func onClick(_ block: @escaping Func) -> Self {
        super.onClick(block)
        inkTouchController.addRipple(to: self)
        return self
    }
}

public extension MDCCard {
    @discardableResult
    override open func construct() -> Self {
        super.construct()
        clipsToBounds = false
        isInteractable = false
        return self
    }

    @discardableResult
    override open func onTouchUp(_ block: @escaping Func) -> Self {
        super.onTouchUp(block)
        isInteractable = true
        isUserInteractionEnabled = true
        return self
    }

    @discardableResult
    override open func onTap(_ block: @escaping Func) -> Self {
        super.onTap(block)
        isInteractable = true
        isUserInteractionEnabled = true
        return self
    }

    @discardableResult
    override open func onTouchDown(_ block: @escaping Func) -> Self {
        super.onTouchDown(block)
        isInteractable = true
        isUserInteractionEnabled = true
        return self
    }
}

extension MDCFloatingButton {
    override open func construct() -> Self {
        super.construct()
        clipsToBounds = false
        return self
    }
}

public extension MDCButton {
    @discardableResult
    override open func construct() -> Self {
        super.construct()
        clipsToBounds = false
        return self
    }
}

public extension MDCMultilineTextField {
    override open func construct() -> Self {
        super.construct()
        clipsToBounds = false
        return self
    }
}

public extension MDCTextField {
    override open func construct() -> Self {
        super.construct()
        clipsToBounds = false
        return self
    }
}
