//
// Created by Rene Dohan on 2/19/20.
//

import Foundation
import RenetikObjc
import UIKit

public class CSPickerController: CSViewController, CSHasPickerVisible, UIPickerViewDelegate, UIPickerViewDataSource {
    public var isPickerVisible: Bool = false

    public var toolBarColor: UIColor?
    public var toolBarItemTextColor: UIColor?
    public var pickerColor: UIColor = .white
    public var pickerItemTextColor: UIColor = .darkText
    public var pickerItemFont: UIFont?

    var items: [CustomStringConvertible]!
    var onDone: ((Int) -> Void)!
    var onCancel: Func?

    @discardableResult
    public func showPicker(from parent: UIViewController, title _: String, 
                           items: [CustomStringConvertible], selected selectedIndex: Int,
                           from _: CSDisplayElement, onCancel: Func?,
                           onDone: @escaping (Int) -> Void) -> CSHasPickerVisible
    {
        super.constructAsViewLess(in: parent)
        self.items = items
        self.onDone = onDone
        self.onCancel = onCancel
        let window = delegate.window!
        UIApplication.resignFirstResponder() // Hide keyboard or whatever so it don't overlap our view
        window.add(disablerView).matchParent()
        layout(disablerView.add(pickerView).matchParentWidth()) { $0.heightToFit().from(bottom: 0) }
        layout(disablerView.add(toolBar).matchParentWidth()) { $0.heightToFit().from(self.pickerView, bottom: 0) }
        window.layoutIfNeeded()
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                           window.layoutIfNeeded()
                           self.disablerView.alpha = 1
                       })
        return self
    }

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView.construct()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = pickerColor
        return picker
    }()

    lazy var disablerView: UIView = {
        let view = UIView().onClick(onCancelClicked)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()

    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        self.toolBarColor?.also { toolBar.barTintColor = $0 }
        self.toolBarItemTextColor?.also { toolBar.tintColor = $0 }
        let cancelButton = UIBarButtonItem(item: .cancel) { _ in self.onCancelClicked() }
        let doneButton = UIBarButtonItem(item: .done) { _ in self.onDoneClicked() }
        toolBar.items = [UIBarButtonItem.space(7), cancelButton, .flexSpaceItem,
                         doneButton, UIBarButtonItem.space(7)]
        return toolBar
    }()

    public func numberOfComponents(in _: UIPickerView) -> Int { 1 }

    public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        items.count
    }

    public func pickerView(_: UIPickerView, attributedTitleForRow row: Int,
                           forComponent _: Int) -> NSAttributedString?
    {
        NSAttributedString(string: String(describing: items[row]),
                           attributes: [.foregroundColor: pickerItemTextColor, .font: pickerItemFont])
    }

    func onDoneClicked() {
        hidePicker()
        onDone?(pickerView.selectedRow(inComponent: 0))
        parent!.dismissChild(controller: self)
    }

    func onCancelClicked() {
        hidePicker()
        onCancel?()
        parent!.dismissChild(controller: self)
    }

    public func hidePicker(animated: Bool = true) {
        invoke(animated: animated, duration: 0.7, operation: {
            self.disablerView.window!.layoutIfNeeded()
            self.disablerView.alpha = 0
        }, completion: {
            self.disablerView.removeFromSuperview()
        })
    }
}
