//
// Created by Rene Dohan on 3/7/20.
//

import Foundation
import RenetikObjc

public class CSSequenceResponse<Data: AnyObject>: CSResponse<Data> {
    var response: CSResponseProtocol!

    override public init() { super.init() }

    @discardableResult
    public func add<Data: AnyObject, Response: CSResponse<Data>>(_ response: Response) -> Response {
        self.response = failIfFail(response)
        return response
    }

    override public func cancel() {
        super.cancel()
        response.cancel()
    }

    @discardableResult
    public func add<Response: CSResponse<Data>>(last request: Response) -> Response {
        add(request).onSuccess { data in self.success(data) }
    }
}
