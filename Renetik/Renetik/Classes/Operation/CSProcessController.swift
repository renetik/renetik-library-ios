//
// Created by Rene Dohan on 3/13/20.
//

import Foundation
import RenetikObjc
import UIKit

public protocol CSProcessController {
    func show<Data: AnyObject>(_ process: CSProcess<Data>, _ title: String, _ progress: Bool, _ canCancel: Bool,
                               _ failedDialog: Bool, _ onSuccess: ((Data) -> Void)?) -> CSProcess<Data>
}

public extension CSProcessController {
    @discardableResult
    func show<Data: AnyObject>(_ process: CSProcess<Data>, title: String = CSStrings.requestLoading,
                               progress: Bool = true, canCancel: Bool = true,
                               failedDialog: Bool = true,
                               onSuccess: ((Data) -> Void)? = nil) -> CSProcess<Data>
    {
        show(process, title, progress, canCancel, failedDialog, onSuccess)
    }
}
