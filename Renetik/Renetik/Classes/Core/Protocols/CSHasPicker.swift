//
// Created by Rene Dohan on 2/19/20.
//

import Foundation

public protocol CSHasPickerVisible {
    var isPickerVisible: Bool { get }
    func hidePicker(animated: Bool)
}

public extension CSHasPickerVisible {
    func hidePicker() { hidePicker(animated: true) }
}

public protocol CSHasPicker {
    @discardableResult
    func show(picker title: String, items: [CustomStringConvertible], selected index: Int,
              from element: CSDisplayElement, onCancel: Func?,
              onDone: @escaping (Int) -> Void) -> CSHasPickerVisible
}

public extension CSHasPicker {
    @discardableResult
    func show(picker title: String, items: [String], selected: Int = 0,
              from view: UIView, onCancel: Func? = nil,
              onDone: @escaping (Int) -> Void) -> CSHasPickerVisible
    {
        show(picker: title, items: items, selected: selected,
             from: CSDisplayElement(view: view), onCancel: onCancel, onDone: onDone)
    }

    @discardableResult
    func show(picker title: String, items: [String], selected: Int = 0,
              from item: UIBarButtonItem, onCancel: Func? = nil,
              onDone: @escaping (Int) -> Void) -> CSHasPickerVisible
    {
        show(picker: title, items: items, selected: selected,
             from: CSDisplayElement(item: item), onCancel: onCancel, onDone: onDone)
    }

    @discardableResult
    func show<T: CustomStringConvertible>(picker title: String, items: [T], selected: Int = 0,
                                          from view: UIView, onCancel: Func? = nil,
                                          onDone: @escaping (T) -> Void) -> CSHasPickerVisible
    {
        show(picker: title, items: items, selected: selected,
             from: CSDisplayElement(view: view), onCancel: onCancel, onDone: { onDone(items[$0]) })
    }

    @discardableResult
    func show<T: CustomStringConvertible>(picker title: String, items: [T], selected: Int = 0,
                                          from item: UIBarButtonItem, onCancel: Func? = nil,
                                          onDone: @escaping (T) -> Void) -> CSHasPickerVisible
    {
        show(picker: title, items: items, selected: selected,
             from: CSDisplayElement(item: item), onCancel: onCancel, onDone: { onDone(items[$0]) })
    }
}
