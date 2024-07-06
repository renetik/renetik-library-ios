//
// Created by Rene Dohan on 3/9/20.
//

import RenetikObjc

public class CSMultiResponse: CSResponse<NSMutableArray> {
    var response: CSResponseProtocol!

    override public init() { super.init(); data = NSMutableArray() }

    @discardableResult
    public func add<Data: AnyObject, Response: CSResponse<Data>>(_ response: Response) -> Response {
        data.add(response.data)
        self.response = failIfFail(response)
        return response
    }

    @discardableResult
    public func add<Data: AnyObject, Response: CSResponse<Data>>(last request: Response) -> Response {
        add(request).onSuccess { _ in self.success() }
    }

    override public func cancel() {
        super.cancel()
        response.cancel()
    }
}
