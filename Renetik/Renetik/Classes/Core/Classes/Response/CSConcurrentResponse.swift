//
//  Renetik Software
//
//  Created by Rene Dohan on 3/14/19.
//

import RenetikObjc

public class CSConcurrentResponse: CSResponse<NSMutableArray> {
    var failedResponse: CSResponseProtocol?
    let responses = CSArray<CSResponseProtocol>() // Cannot use swift array because of equatable shit

    override public init() { super.init(); data = NSMutableArray() }

    public init<T: AnyObject>(_ response: CSResponse<T>) { super.init(); add(response) }

    @discardableResult
    public func add<T: AnyObject>(_ response: CSResponse<T>) -> CSResponse<T> {
        data!.add(response.data!)
        responses.add(response)
        response.onFailed { _ in self.onResponseFailed(response) }
            .onSuccess { _ in self.onResponseSuccess(response) }
        return response
    }

    public func onAddDone() { later { if self.responses.isEmpty { self.success(self.data) } } }

    func onResponseSuccess<T: AnyObject>(_ response: CSResponse<T>) {
        responses.remove(response)
        if responses.isEmpty { success(data) }
    }

    func onResponseFailed<T: AnyObject>(_ failedResponse: CSResponse<T>) {
        self.failedResponse = failedResponse
        responses.remove(failedResponse).forEach { $0.cancel() }
        failed(failedResponse)
    }

    override open func cancel() { responses.forEach { $0.cancel() }; super.cancel() }
}
