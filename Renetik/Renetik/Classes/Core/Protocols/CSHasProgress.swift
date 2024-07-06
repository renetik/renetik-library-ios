//
// Created by Rene Dohan on 1/11/20.
//

import Foundation

public protocol CSHasProgress {
    func show(progress title: String, cancel: CSDialogAction?) -> CSHasDialogVisible
}

public extension CSHasProgress {
    func show(progress title: String, onCancel: Func? = nil) -> CSHasDialogVisible {
        show(progress: title, cancel: onCancel.notNil ?
            CSDialogAction(title: CSStrings.dialogCancel, action: onCancel!) : nil)
    }
}
