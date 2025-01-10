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
    var params: [(String, Any)] = []
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
    
    public convenience init(_ url: String, _ service: String,
                            _ data: Data, _ params: [(String, Any)]) {
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

public enum CSResultState {
    case success
    case cancel
    case failure
}

public class CSResult<Value> {
    public let state: CSResultState
    public let value: Value?
    public var throwable: Error?
    public var message: String?
    public var isSuccess: Bool { state == .success }
    public var failureMessage: String {
        "\(throwable.asString) \(message.asString)"
    }
    public var isFailure: Bool { state == .failure }
    
    public init(state: CSResultState, value: Value? = nil, throwable: Error? = nil, message: String? = nil) {
        self.state = state
        self.value = value
        self.throwable = throwable
        self.message = message
    }
    
    @discardableResult
    public func ifSuccess(_ function: @escaping (Value) async throws -> Void) async -> CSResult {
        if state == .success, let value = value {
            do {
                try await function(value)
            } catch {
                throwable = error
            }
        }
        return self
    }
    
    @discardableResult
    public func ifSuccess(_ function: @escaping () async throws -> Void) async -> CSResult {
        if state == .success, let value = value {
            do {
                try await function()
            } catch {
                throwable = error
            }
        }
        return self
    }
    
    @discardableResult
    public func ifSuccess(dispatcher: DispatchQueue, function: @escaping (Value) async throws -> Void) async -> CSResult {
        if state == .success, let value = value {
            dispatcher.async {
                Task {
                    do {
                        try await function(value)
                    } catch {
                        self.throwable = error
                    }
                }
            }
        }
        return self
    }
    
    @discardableResult
    public func ifSuccessReturn<T>(_ function: @escaping (Value) async throws -> CSResult<T>) async -> CSResult<T> {
        if state == .success, let value = value {
            do {
                return try await function(value)
            } catch {
                return CSResult<T>(state: .failure, throwable: error)
            }
        } else {
            return CSResult<T>(state: state, throwable: throwable, message: message)
        }
    }
    
    @discardableResult
    public func ifSuccessConvert<T, U>(_ function: @escaping (T) -> U) async -> CSResult<U> where Value == T {
        if state == .success, let value = value {
            let converted = function(value)
            return CSResult<U>(state: .success, value: converted)
        } else {
            return CSResult<U>(state: state, throwable: throwable, message: message)
        }
    }
    
    @discardableResult
    public func ifNotSuccess(_ function: @escaping () -> Void) async -> CSResult {
        if state == .failure || state == .cancel {
            function()
        }
        return self
    }
    
    @discardableResult
    public  func ifFailure(_ function: @escaping (CSResult) -> Void) async -> CSResult {
        if state == .failure {
            function(self)
        }
        return self
    }
    
    @discardableResult
    public  func ifFailure(_ function: @escaping () -> Void) async -> CSResult {
        if state == .failure {
            function()
        }
        return self
    }
    
    @discardableResult
    public   func ifCancel(_ function: @escaping () -> Void) async -> CSResult {
        if state == .cancel {
            function()
        }
        return self
    }
    
    public  static var success: CSResult<Void> { CSResult<Void>(state: .success, value: ()) }
    
    public  static func success<Value>(value: Value) -> CSResult<Value> { CSResult<Value>(state: .success, value: value) }
    
    public  static var canceled: CSResult<Void> { CSResult<Void>(state: .cancel, value: ()) }
    
    public  static func cancel<Value>() -> CSResult<Value> { CSResult<Value>(state: .cancel, value: nil) }
    
    public  static func failure<Value>(throwable: Error? = nil, message: String? = nil) -> CSResult<Value> {
        CSResult<Value>(state: .failure, value: nil, throwable: throwable, message: message)
    }
    
    public  static func failure<Value>(message: String) -> CSResult<Value> {
        CSResult<Value>(state: .failure, value: nil, message: message)
    }
}

extension CSResponse {
    public func awaitResult() async -> CSResult<Data> {
        return await withCheckedContinuation { continuation in
            self.onSuccess { data in
                continuation.resume(returning: CSResult<Data>.success(value: data))
            }
            self.onFailed { response in
                let error = NSError(
                    domain: "CSResponse",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: response.message]
                )
                continuation.resume(returning: CSResult<Data>.failure(throwable: error, message: response.message))
            }
            self.onCancel {
                let cancelError = NSError(
                    domain: "CSResponse",
                    code: -999,
                    userInfo: [NSLocalizedDescriptionKey: self.requestCancelledMessage]
                )
                continuation.resume(returning: CSResult<Data>.cancel())
            }
        }
    }
}

