//
// Created by Rene Dohan on 12/30/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Foundation
import Renetik

public protocol CSOperationController {
    @discardableResult
    func send<Data>(_ operation: CSOperation<Data>, _ progress: Bool, _ canCancel: Bool,
                    _ failedDialog: Bool, _ onSuccess: ((Data) -> Void)?) -> CSProcess<Data>
}

public extension CSOperationController {
    @discardableResult
    func send<Data>(operation: CSOperation<Data>, progress: Bool = true, canCancel: Bool = true,
                    failedDialog: Bool = true, onSuccess: ((Data) -> Void)? = nil) -> CSProcess<Data>
    {
        send(operation, progress, canCancel, failedDialog, onSuccess)
    }
}
