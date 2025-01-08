//
// Created by Rene Dohan on 1/10/20.
//

import Foundation
import RenetikObjc

public extension CSOperation where Data: AnyObject {
    convenience init(title: String, request: @escaping () -> CSResponse<Data>) {
        self.init(title: title, function: { operation in
            let response = request()
            response.force(operation.isRefresh)
            let process = CSProcess(response.data)
            response.onSuccess { data in process.success(data) }
            response.onFailed { it in process.failed(it.message ?? .requestFailed) }
            return process
        })
    }
}
