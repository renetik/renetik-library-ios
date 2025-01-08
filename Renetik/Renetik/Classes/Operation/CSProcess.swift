//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Foundation

public class CSProcess<Data>: CSAny, CSProcessProtocol {
    private let eventSuccess: CSEvent<CSProcess<Data>> = event()

    @discardableResult
    public func onSuccess(_ function: @escaping (Data) -> Void) -> Self {
        eventSuccess.invoke { function($0.data!) }
        return self
    }

    private let eventFailed: CSEvent<CSProcessProtocol> = event()

    @discardableResult
    public func onFailed(_ function: @escaping (CSProcessProtocol) -> Void) -> Self {
        invoke { eventFailed.invoke { function($0) } }
    }

    private let eventCancel: CSEvent<CSProcess<Data>> = event()

    @discardableResult
    public func onCancel(_ function: @escaping (CSProcess<Data>) -> Void) -> Self {
        invoke { eventCancel.invoke { function($0) } }
    }

    public let eventDone: CSEvent<Data?> = event()

    @discardableResult
    public func onDone(_ function: @escaping (Data?) -> Void) -> Self {
        invoke { eventDone.invoke { function($0) } }
    }

    private let onProgress: CSEvent<CSProcess<Data>> = event()
    var progress: UInt64 = 0 { didSet { onProgress.fire(self) } }
    var isSuccess = false
    var isFailed = false
    var isDone = false
    var isCanceled = false
    var url: String? = nil
    var data: Data? = nil
    public var message: String? = nil
    public var error: Error? = nil
    var failedProcess: CSProcessProtocol? = nil

    public init(_ url: String, _ data: Data) {
        self.url = url
        self.data = data
    }

    public init(_ data: Data?) { self.data = data }

    @discardableResult
    public func success() {
        if isCanceled { return }
        onSuccessImpl()
        onDoneImpl()
    }

    @discardableResult
    public func success(_ data: Data) {
        if isCanceled { return }
        self.data = data
        onSuccessImpl()
        onDoneImpl()
    }

    private func onSuccessImpl() {
        logInfo("Response onSuccessImpl \(self) \(url.asString)")
        if isFailed { logError("already failed") }
        if isSuccess { logError("already success") }
        if isDone { logError("already done") }
        isSuccess = true
        eventSuccess.fire(self)
    }

    @discardableResult
    public func failed(_ process: CSProcessProtocol) {
        if isCanceled { return }
        onFailedImpl(process)
        onDoneImpl()
    }

    @discardableResult
    public func failed(_ message: String) -> CSProcess<Data> {
        if isCanceled { return self }
        self.message = message
        failed(self)
        return self
    }

    @discardableResult
    public func failed(_ error: Error?, message: String? = nil) {
        if isCanceled { return }
        self.error = error
        self.message = message ?? error?.localizedDescription ?? .operationFailed
        failed(self)
    }

    private func onFailedImpl(_ process: CSProcessProtocol) {
        if isFailed { logError("already failed") }
        if isDone { logError("already done") }
        failedProcess = process
        isFailed = true
        message = process.message
        error = process.error
        logError("\(message.asString), \(error.asString.asString)")
        eventFailed.fire(process)
    }

    open func cancel() {
        logInfo("Response cancel \(self) isCanceled \(isCanceled) isDone \(isDone) " +
            "isSuccess \(isSuccess) isFailed \(isFailed)")
        if isCanceled || isDone || isSuccess || isFailed { return }
        isCanceled = true
        message = .operationCancelled
        eventCancel.fire(self)
        onDoneImpl()
    }

    private func onDoneImpl() {
        logInfo()
        if isDone {
            logError("isDone")
            return
        }
        isDone = true
        eventDone.fire(data)
    }
}
