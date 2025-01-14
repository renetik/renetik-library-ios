//
// Created by Rene Dohan on 1/25/20.
//

import BlocksKit
import RenetikObjc
import UIKit

public struct CSTextViewClearButtonAppearance {
    private let titleColor: UIColor?

    public init(titleColor: UIColor) {
        self.titleColor = titleColor
    }
}

public extension UITextView {
    func delegate(_ delegate: UITextViewDelegate) -> Self { self.delegate = delegate; return self }

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

    func scrollToCursorPosition() -> Self {
        later(seconds: 0.1) {
            if let start = self.selectedTextRange?.start {
                self.scrollRectToVisible(self.caretRect(for: start), animated: true)
            }
        }
        return self
    }

    // TODO: detect(data:[.all, .links]
    @discardableResult
    func detectData(_ types: UIDataDetectorTypes = [.all]) -> Self {
        dataDetectorTypes = types
        if types.isEmpty { isSelectable = true }
        return self
    }

    @discardableResult
    override func onTap(_ block: @escaping Func) -> Self {
        isEditable = false
        isSelectable = false
        super.onTap(block)
        return self
    }

//    TODO: This is wrong and TextView should be wrapped to view with clear button instead
//    @discardableResult
//    func withClear(_ parent: CSViewController, _ appearance: CSTextViewClearButtonAppearance? = nil) -> Self {
//        let button = UIButton(type: .system).construct().text("X").fontStyle(.body)
//                .visible(if: self.text.isSet).onClick { self.text = "" }
//        add(button).from(left: 5).resizeToFit().centeredHorizontal()
//
//        onTextChange(in: parent) { _ in button.visible(if: self.text.isSet) }
//        appearance?.titleColor?.then { color in button.textColor(color) }
//        return self
//    }

    @discardableResult
    func text(_ value: String?) -> Self { invoke { self.text = value } }

    @discardableResult
    func onTextChange(in parent: CSViewController, _ function: @escaping (UITextView) -> Void) -> Self {
        parent.observe(notification: UITextView.textDidChangeNotification) { notification in
            if (notification.object as! NSObject) === self { function(self) }
        }
        return self
    }

    @discardableResult
    func heightToFit(lines numberOfLines: Int) -> Self {
        let currentWidth = width; let currentText = text; var linesText = "line"
        for i in 0 ..< numberOfLines - 1 {
            linesText += "\n line"
        }
        text(linesText).resizeToFit().text(currentText).width(currentWidth)
        return self
    }

    @discardableResult
    func asLabel() -> Self {
        textAlignment = .left
        textContainerInset = .zero
        contentInset = .zero
        isEditable = false
        isScrollEnabled = false
        backgroundColor = .clear
        contentInsetAdjustmentBehavior = .never
        textContainer.lineFragmentPadding = 0
        layoutManager.usesFontLeading = false
        return self
    }
    
    func centerTextVertical() -> Self {
        let textHeight = heightThatFits()
        let topInset = (height - textHeight) / 2
        textContainerInset = UIEdgeInsets(top: topInset)
        return self
    }

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
