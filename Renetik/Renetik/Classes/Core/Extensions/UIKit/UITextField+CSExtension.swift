//
// Created by Rene Dohan on 1/4/20.
//

import BlocksKit
import Foundation
import UIKit

public extension UITextField {
    @objc func caretRect(for _: UITextPosition) -> CGRect { CGRect.zero }

    @discardableResult
    func clear() -> Self { invoke { self.text = "" } }

    @discardableResult
    func togglePasswordVisibility() -> Self {
        isSecureTextEntry = !isSecureTextEntry
        let existingText = text
        if isSecureTextEntry {
            deleteBackward()
            text = existingText
        }
        return self
    }

    @discardableResult
    func leftInsetByLeftView(width: CGFloat) -> Self {
        let leftView = UIView.construct(width: width, height: 1)
        leftView.backgroundColor = backgroundColor
        self.leftView = leftView
        leftViewMode = .always
        return self
    }

    @discardableResult
    func onChange(_ function: @escaping (UITextField) -> Void) -> Self {
        bk_addObserver(forKeyPath: "text") { _ in function(self) }
        return self
    }

    @discardableResult
    func onClear(_ function: @escaping (UITextField) -> Void) -> Self {
        bk_shouldClearBlock = { _ in
            function(self)
            return true
        }
        return self
    }

    @discardableResult
    func html(_ text: String) -> Self {
        let htmlStyleFormat = "<style>body{font-family: '%@'; font-size:%fpx;}</style>"
        let html = (text + String(format: htmlStyleFormat, font!.fontName, font!.pointSize))
        let htmlData = html.data(using: .unicode, allowLossyConversion: true)
        htmlData.notNil { data in
            attributedText = try? NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html, .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
            ], documentAttributes: nil)
        }
        return self
    }

    @discardableResult
    func text(_ value: String?) -> Self { invoke { self.text = value } }

    // TODO: text(align:
    @discardableResult
    func alignText(_ alignment: NSTextAlignment) -> Self { invoke { self.textAlignment = alignment } }

    // TODO: text(color:
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self { invoke { self.textColor = textColor } }

    @discardableResult
    func font(_ font: UIFont) -> Self { invoke { self.font = font } }

    // TODO: font(size:
    @discardableResult
    func fontSize(_ size: CGFloat) -> Self { invoke { self.fontSize = size } }

    var fontSize: CGFloat {
        get { font!.fontDescriptor.pointSize }
        set { font = font!.withSize(newValue) }
    }

    // TODO: font(style:
    @discardableResult
    func fontStyle(_ style: UIFont.TextStyle) -> Self { invoke { self.fontStyle = style } }

    var fontStyle: UIFont.TextStyle {
        get { font!.fontDescriptor.object(forKey: .textStyle) as! UIFont.TextStyle }
        set { font = UIFont.preferredFont(forTextStyle: newValue) }
    }
}
