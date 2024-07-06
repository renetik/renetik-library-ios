//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik
import RenetikObjc

public protocol CSOperationProtocol {
    func onFailed(_ function: @escaping (CSProcessProtocol) -> Void) -> Self
}

public class CSOperation<Data>: CSAny, CSOperationProtocol {
    public let title: String
    public var data: Data?
    private let executeProcessFunction: (CSOperation<Data>) -> CSProcess<Data>

    public init(title: String, function: @escaping (CSOperation<Data>) -> CSProcess<Data>) {
        executeProcessFunction = function
        self.title = title
    }

    open func executeProcess() -> CSProcess<Data> { executeProcessFunction(self) }

    private let eventSuccess: CSEvent<Data> = event()

    @discardableResult
    public func onSuccess(_ function: @escaping (Data) -> Void) -> Self {
        invoke { eventSuccess.invoke { function($0) } }
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

    private var process: CSProcess<Data>? = nil
    public var isCached = true
    public var isRefresh = false
    public var expireMinutes: Int? = 1

    public var isLoading: Bool { process?.isDone == false }

    @discardableResult
    public func refresh(_: Bool = true) -> Self { invoke { isRefresh = true } }

    @discardableResult
    public func expire(minutes: Int?) -> Self { invoke { expireMinutes = minutes } }

    public func send(listenOnFailed: Bool = true) -> CSProcess<Data> {
        executeProcess().also { process in
            self.process = process
            process.onSuccess { data in
                self.data = data
                self.eventSuccess.fire(process.data!)
                self.eventDone.fire(process.data)
            }
            if listenOnFailed { process.onFailed(self.failed) }
        }
    }

    public func cancel() {
        process.notNil { process in
            if process.isFailed {
                self.eventFailed.fire(process)
                self.eventDone.fire(process.data)
            } else {
                process.cancel()
                self.eventDone.fire(process.data)
            }
        }
    }

    public func failed(process: CSProcessProtocol) {
        eventFailed.fire(process)
        eventDone.fire(self.process?.data)
        self.process = nil
    }
}
