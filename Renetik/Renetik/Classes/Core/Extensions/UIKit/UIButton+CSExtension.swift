//
//  File.swift
//  Renetik
//
//  Created by Rene Dohan on 3/9/19.
//

import UIKit
import RenetikObjc

public extension UIButton {

    @discardableResult
    class func construct(_ image: UIImage) -> Self { construct().image(image) }

    @discardableResult
    class func construct(_ text: String) -> Self { construct().text(text) }

    @discardableResult
    override open func construct() -> Self {
        super.construct().aspectFit().resizeToFit()
        return self
    }

    @discardableResult
    public func alignContent(_ alignment: ContentHorizontalAlignment) -> Self {
        contentHorizontalAlignment = alignment
        return self
    }

    public var text: String {
        get { title(for: .normal) ?? "" }
        set(value) { text(value) }
    }

    @discardableResult
    func fontStyle(_ style: UIFont.TextStyle) -> Self {
        titleLabel?.fontStyle = style
        return self
    }

    public var font: UIFont? {
        get { titleLabel?.font }
        set(value) { titleLabel?.font = value }
    }

    @discardableResult
    @objc open func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    @discardableResult
    public func text(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    @discardableResult
    public func image(_ image: UIImage) -> Self {
        setImage(image, for: .normal)
        return self
    }

    @discardableResult
    public func image(template image: UIImage) -> Self { self.image(image.template) }

    public var textColor: UIColor? {
        get { titleColor(for: .normal) }
        set(value) { setTitleColor(value, for: .normal) }
    }

    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }

    @discardableResult
    override func aspectFit() -> Self {
        imageView?.aspectFit()
        return self
    }

    @discardableResult
    override func aspectFill() -> Self {
        imageView?.aspectFill()
        return self
    }

    func floatingDown(distance: CGFloat = 25) -> Self {
        from(bottom: distance, right: distance)
        if UIDevice.isTablet { resize(padding: 5) }
        imageEdgeInsets = UIEdgeInsets(UIDevice.isTablet ? 20 : 15)
        return self
    }

    func floatingUp(distance: CGFloat = 25) -> Self {
        from(top: distance, right: distance)
        if UIDevice.isTablet { resize(padding: 5) }
        imageEdgeInsets = UIEdgeInsets(UIDevice.isTablet ? 20 : 15)
        return self
    }
}
