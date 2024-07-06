//
// Created by Rene Dohan on 3/8/20.
//

import AFNetworking
import Foundation

public protocol CSResponseProtocol: NSObjectProtocol {
    var message: String { get }
    func onSuccess(_ onSuccess: @escaping Func)
    func onFailed(_ onFailed: @escaping (CSResponseProtocol) -> Void) -> Self
    func cancel()
}

enum CSRequestType: Int {
    case get
    case post
}

public class CSResponse<Data: AnyObject>: NSObject, CSResponseProtocol {
    private(set) var url = ""
    private(set) var service = ""
    public private(set) var isSuccess = false
    public private(set) var isFailed = false
    public private(set) var isCanceled = false
    public private(set) var isDone = false

    public var data: Data!
    var content: String?
    private var _message: String?
    var requestCancelledMessage = "Request cancelled."
    var errorCode = 0
    var params: [AnyHashable: Any] = [:]
    var post: [AnyHashable: Any] = [:]
    var forceReload = false
    var fromCacheIfPossible = false
    public weak var controller: UIViewController?
    var type: CSRequestType?
    var form: ((_ formData: AFMultipartFormData) -> Void)?

    private let onFailedEvent: CSEvent<CSResponseProtocol> = event()
    private let onProgressEvent: CSEvent<Double> = event()
    private let onSuccessEvent: CSEvent<Data> = event()
    private let onCancelEvent: CSEvent<Void> = event()
    private let onDoneEvent: CSEvent<Data?> = event()
    private var id = ""
    private var failedResponse: CSResponseProtocol?

//    override public init() {
//        super.init()
//    }

    public convenience init(_ url: String, _ service: String, _ data: Data, _ params: [AnyHashable: Any]) {
        self.init()
        self.url = url
        self.service = service
        self.data = data
        self.params = params
        logInfo("\(url) \(service) \(params)")
    }

    public convenience init(_ data: Data) {
        self.init()
        self.data = data
        logInfo("\(url) \(service) \(params)")
    }

    override public var description: String {
        "url:\(url) service:\(service) message:\(message) params:\(params) post:\(post) content:\(content)"
    }

    @discardableResult
    public func setProgress(_ completed: Double) -> Self {
        onProgressEvent.fire(completed)
        return self
    }

    public func success() { success(data) }

    public func success(_ data: Data) {
        if isDone { return }
        self.data = data
        isSuccess = true
        onSuccessEvent.fire(self.data)
        done()
    }

    public func failed(_ response: CSResponseProtocol) {
        if isDone {
            return
        }
        isFailed = true
        failedResponse = response
        logInfo("Response failed \(response.message)")
        onFailedEvent.fire(response)
        done()
    }

    @discardableResult
    public func failed(message: String) -> Self {
        if isDone {
            return self
        }
        _message = message
        failed(self)
        return self
    }

    open func cancel() {
        _message = requestCancelledMessage
        isCanceled = true
        onCancelEvent.fire()
        done()
    }

    private func done() {
        isDone = true
        onDoneEvent.fire(data)
    }

    @discardableResult
    public func onSuccess(_ onSuccess: @escaping (Data) -> Void) -> Self {
        onSuccessEvent.invoke { onSuccess($0) }
        return self
    }

    @discardableResult
    public func onSuccess(_ onSuccess: @escaping Func) { onSuccessEvent.invoke { _ in onSuccess() } }

    @discardableResult
    public func onCancel(_ onCancel: @escaping Func) -> Self {
        onCancelEvent.invoke(listener: onCancel)
        return self
    }

    @discardableResult
    public func onDone(_ onDone: @escaping (Data?) -> Void) -> Self {
        onDoneEvent.invoke { onDone($0) }
        return self
    }

    @discardableResult
    public func onFailed(_ onFailed: @escaping (CSResponseProtocol) -> Void) -> Self {
        onFailedEvent.invoke { onFailed($0) }
        return self
    }

    @discardableResult
    public func failIfFail<Data: AnyObject>(_ response: CSResponse<Data>) -> CSResponse<Data> {
        response.onFailed { self.failed($0) }
    }

    @discardableResult
    public func successIfSuccess(_ response: CSResponse<Data>) -> CSResponse<Data> {
        response.onSuccess { self.success($0) }
    }

    @discardableResult
    public func connect(_ response: CSResponse<Data>) -> CSResponse<Data> {
        failIfFail(response)
        successIfSuccess(response)
        return response
    }

//
//
//    func onProgress(_ onProgress: @escaping (NSNumber?) -> Void) -> Self {
//        onProgressEvent.add({ progress, registration in
//            onProgress(progress)
//        })
//        return self
//    }
//
    @discardableResult
    public func force(_ reload: Bool) -> Self {
        forceReload = reload
        return self
    }

    @discardableResult
    public func fromCacheIfPossible(_ force: Bool) -> Self {
        fromCacheIfPossible = force
        return self
    }

    public var message: String {
        if _message.isNil && failedResponse.notNil {
            return failedResponse!.message
        }
        return _message ?? "No response message"
    }
}
