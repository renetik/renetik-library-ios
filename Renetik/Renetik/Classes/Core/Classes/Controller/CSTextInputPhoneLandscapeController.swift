//
// Created by Rene Dohan on 12/22/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Foundation
import RenetikObjc
import UIKit
import UITextView_Placeholder

public protocol CSHasInputAccessory: NSObjectProtocol {
    var inputAccessoryView: UIView? { get set }
}

public protocol CSHasUIResponder: NSObjectProtocol {
    var responder: UIResponder { get }
}

public protocol CSHasTextInput: NSObjectProtocol {
    var textInput: UITextInput? { get set }
}

extension UITextView: CSHasInputAccessory {}

public class CSTextInputPhoneLandscapeController: CSViewController {
    public let defaultAccessoryView = CSInputAccessoryDone()
    private let keyboardManager = CSKeyboardManager()
    public let container = UIView.construct(width: 100, height: 50).background(.white)
    public let textView = UITextView.construct().background(.white)
    public let actionButton = UIButton.construct().textColor(.blue)
    private var parentTextInput: (CSHasTextProtocol & CSHasUIResponder)!
    private var hasAccessory: CSHasInputAccessory?
    private var accessoryTextInput: UITextInput?

    @discardableResult
    func construct(by parent: CSViewController, textInput: CSHasTextProtocol & CSHasUIResponder,
                   hasAccessory: CSHasInputAccessory? = nil, placeHolder: String, hideImage: UIImage,
                   action: (title: String?, image: UIImage?, function: Func)?) -> Self
    {
        constructAsViewLess(in: parent)
        parentTextInput = textInput
        self.hasAccessory = hasAccessory
        accessoryTextInput = (hasAccessory?.inputAccessoryView as? CSHasTextInput)?.textInput
        textView.placeholder = placeHolder
        textView.inputAccessoryView = defaultAccessoryView.construct(hideImage)
        keyboardManager.construct(self) { _ in self.onKeyboardChange() }
        action.notNil { action in
            action.title.notNil { actionButton.text($0).resizeToFit() }
            action.image.notNil { actionButton.image($0).size(40) }
            actionButton.onClick {
                self.parentTextInput.text = self.textView.text
                action.function()
            }
        }.elseDo {
            actionButton.size(0)
        }
        return self
    }

    override public func onCreateLayout() {
        layout(container.add(view: actionButton).centeredVertical()) {
            $0.from(right: self.safeArea.right)
        }
        layout(container.add(view: textView).matchParentHeight(margin: 5)) {
            logInfo(self.container.size)
            $0.from(left: self.safeArea.left).width(from: self.actionButton, right: 5)
        }
    }

    override public func onViewDidLayout() { updateVisibility() }

    private func onKeyboardChange() {
        if parentTextInput.responder.isFirstResponder && UIScreen.isShort {
            textView.text = parentTextInput.text
            changeAccessory(from: hasAccessory, to: textView, textInput: textView)
            delegate.window!.add(view: container).matchParent()
            textView.becomeFirstResponder()
            runLayoutFunctions()
            return
        }
        if textView.isFirstResponder && UIScreen.isShort {
            container.height(fromBottom: keyboardManager.keyboardHeight)
            runLayoutFunctions()
            return
        }
        updateVisibility()
    }

    private func updateVisibility() {
        if !UIScreen.isShort && isActive { hide() }
        if !textView.isFirstResponder && isActive { hide() }
    }

    private func hide() {
        container.removeFromSuperview() // Have to be here so isActive returns false and cycle is prevented
        parentTextInput.text = textView.text
        changeAccessory(from: textView, to: hasAccessory, textInput: accessoryTextInput)
        textView.resignFirstResponder()
    }

    private func changeAccessory(from hasAccessory1: CSHasInputAccessory?,
                                 to hasAccessory2: CSHasInputAccessory?, textInput: UITextInput?)
    {
        let accessoryView = hasAccessory1?.inputAccessoryView
        textInput.notNil { input in (accessoryView as? CSHasTextInput)?.textInput = input }
        accessoryView.notNil { hasAccessory2?.inputAccessoryView = $0 }
    }

    private var isActive: Bool { container.superview.notNil }
}

public extension CSTextInputPhoneLandscapeController {
    @discardableResult
    func construct(by parent: CSViewController,
                   textInput: CSHasTextProtocol & CSHasUIResponder & CSHasInputAccessory,
                   placeHolder: String = "Enter text", hideImage: UIImage,
                   doneTitle: String = "Done") -> Self
    {
        construct(by: parent, textInput: textInput, hasAccessory: textInput,
                  placeHolder: placeHolder, hideImage: hideImage, doneTitle: doneTitle)
    }

    @discardableResult
    func construct(by parent: CSViewController, textInput: CSHasTextProtocol & CSHasUIResponder,
                   hasAccessory: CSHasInputAccessory? = nil, placeHolder: String = "Enter text",
                   hideImage: UIImage, doneTitle: String = "Done") -> Self
    {
        construct(by: parent, textInput: textInput, hasAccessory: hasAccessory, placeHolder: placeHolder,
                  hideImage: hideImage, action: (title: doneTitle, image: nil, function: {
                      self.textView.resignFirstResponder()
                  }))
    }

    @discardableResult
    func construct(by parent: CSViewController,
                   textInput: CSHasTextProtocol & CSHasUIResponder & CSHasInputAccessory,
                   placeHolder: String, hideImage: UIImage, action: CSImageAction) -> Self
    {
        construct(by: parent, textInput: textInput, hasAccessory: textInput,
                  placeHolder: placeHolder, hideImage: hideImage,
                  action: (title: nil, image: action.image, function: action.function))
    }

    @discardableResult
    func construct(by parent: CSViewController,
                   textInput: CSHasTextProtocol & CSHasUIResponder & CSHasInputAccessory,
                   placeHolder: String, hideImage: UIImage, action: CSTextAction) -> Self
    {
        construct(by: parent, textInput: textInput, hasAccessory: textInput, placeHolder: placeHolder,
                  hideImage: hideImage, action: (title: action.title, image: nil, function: action.function))
    }

    @discardableResult
    func construct(by parent: CSViewController, textInput: CSHasTextProtocol & CSHasUIResponder,
                   hasAccessory: CSHasInputAccessory? = nil, placeHolder: String = "Enter text",
                   hideImage: UIImage) -> Self
    {
        construct(by: parent, textInput: textInput, hasAccessory: hasAccessory,
                  placeHolder: placeHolder, hideImage: hideImage, action: nil)
    }
}

public class CSInputAccessoryDone: UIView {
    let hideKeyboardButton = UIButton.construct()
        .tint(color: .darkText).onClick { UIApplication.resignFirstResponder() }

    func construct(_ keyboardHide: UIImage) -> Self {
        super.construct().width(400, height: 40).background(.white)
        add(hideKeyboardButton.image(keyboardHide.template)).matchParentHeight()
            .widthAsHeight().from(left: safeArea.left)
        return self
    }
}
