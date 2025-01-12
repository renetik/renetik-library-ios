//
// Created by Rene Dohan on 9/5/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Renetik

open class CSLabeledText: UIView {
    public let label = UILabel()
    public let textView = UITextView()
    public var onClick: Func?

    @discardableResult
    func construct(_ container: UIView, _ title: String?, _ value: String?,
                   _ dataTypes: UIDataDetectorTypes? = nil, _ onClick: Func? = nil) -> Self
    {
        super.construct().width(200, height: 30)
        addLabel(title: title)
        addTextView(value: value)
        textView.textContainer.lineBreakMode = .byTruncatingHead
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.scrollRangeToVisible(
            NSMakeRange(textView.text.count - 1, 0))
        dataTypes.notNil { textView.detectData($0) }
        self.onClick = onClick
        onClick.notNil { textView.onClick($0) }
        (container.content ?? container).add(view: self)
            .fromPrevious(top: 0).matchParentWidth()
        return self
    }

    private func addTextView(value: String?) {
        add(view: textView).from(left: label.right + 5)
            .width(fromRight: 5, flexible: true).matchParentHeight()
        textView.textAlignment = .left
        textView.asLabel().textContainerInset = UIEdgeInsets(top: 5)
        textView.text(value)
    }

    private func addLabel(title: String?) {
        add(view: label).from(left: 10).width(110).matchParentHeight()
        label.text(title)
    }
}

public class CSLabeledView: UIView {
    public let label = UILabel()
    private var view: UIView!

    @discardableResult
    func construct(_ container: UIView, _ title: String, _ view: UIView, _ onClick: Func?) -> Self {
        super.construct().width(200, height: 30)
        add(view: label).from(left: 10).width(110).matchParentHeight().text(title)
        add(view: view).from(left: label.right + 5).centerVertical(as: label)
        (container.content ?? container).add(view: self).fromPrevious(top: 0).matchParentWidth()
        onClick.notNil {
            view.onClick($0)
            self.onClick($0)
        }
        return self
    }
}

public extension UIView {
    func addField(title: String? = nil, text: String? = nil,
                  detect dataTypes: UIDataDetectorTypes? = nil, 
                  onClick: Func? = nil)
    {
        CSLabeledText().construct(self, title, text, dataTypes, onClick)
    }

    func addField(title: String, view: UIView, onClick: Func? = nil) {
        CSLabeledView().construct(self, title, view, onClick)
    }
}
