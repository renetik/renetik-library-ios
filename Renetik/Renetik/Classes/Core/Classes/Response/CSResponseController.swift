//
// Created by Rene Dohan on 12/22/19.
//

import Foundation
import RenetikObjc
import UIKit

public protocol CSResponseController {
    func show<T: AnyObject>(_ response: CSResponse<T>, _ title: String, _ progress: Bool, _ canCancel: Bool,
                            _ failedDialog: Bool, _ onSuccess: ((T) -> Void)?) -> CSResponse<T>
}

public extension CSResponseController {
    @discardableResult
    func show<Data: AnyObject>(_ response: CSResponse<Data>, title: String = CSStrings.requestLoading,
                               progress: Bool = true, canCancel: Bool = true,
                               failedDialog: Bool = true,
                               onSuccess: ((Data) -> Void)? = nil) -> CSResponse<Data>
    {
        show(response, title, progress, canCancel, failedDialog, onSuccess)
    }
}
