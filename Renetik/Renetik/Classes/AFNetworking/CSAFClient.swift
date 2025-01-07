//
//  CSAFClient.swift
//  Motorkari
//
//  Created by Rene Dohan on 1/28/19.
//  Copyright © 2019 Renetik Software. All rights reserved.
//

import AFNetworking
import RenetikObjc

open class CSAFClient: CSObject {
    public let url: String
    public let manager: AFHTTPSessionManager
    var defaultParams: [(String, String)] = []
    public var requestFailMessage = "Request failed"
    public var requestCancelMessage = "Request cancelled"

    public init(url: String) {
        self.url = url
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        manager = AFHTTPSessionManager(baseURL: URL(string: url),
                                       sessionConfiguration: configuration)
        manager.responseSerializer = AFHTTPResponseSerializer()
    }

    public func setVagueSecurityPolicy() {
        var policy = AFSecurityPolicy(pinningMode: .none)
        policy.allowInvalidCertificates = true
        policy.validatesDomainName = false
        manager.securityPolicy = policy
    }

    public func addDefault(params: [(String, String)]) {
        defaultParams.add(array: params)
    }

    public func clearDefaultParams() {
        defaultParams.removeAll()
    }

    public func acceptable(contentTypes: [String]) {
        manager.responseSerializer.acceptableContentTypes = Set<String>(contentTypes)
    }

    public func basicAuthentication(username: String, password: String) {
        manager.requestSerializer
            .setAuthorizationHeaderFieldWithUsername(username, password: password)
    }
    
    open func get<Data: CSServerData>(
        service: String, data: Data,
        params: [String: Any?]
    ) -> CSResponse<Data> {
        return get(service:service, data:data, params:params.map{($0,$1)})
    }

    open func get<Data: CSServerData>(
        service: String, data: Data,
        params: [(String, Any?)] = []
    ) -> CSResponse<Data> {
        let request = CSResponse(url, service, data, createParams(params))
        request.requestCancelledMessage = requestCancelMessage
        request.type = .get
        let response = CSAFResponse(self, request)
        later {
            self.execute(request, response)
        }
        return request
    }

    open func post<Data: CSServerData>(
        service: String, data: Data,
        params: [(String, Any?)] = [],
        form: @escaping (AFMultipartFormData) -> Void
    ) -> CSResponse<Data> {
        let completeParams = createParams(params)
        let request = CSResponse(url, service, data, completeParams)
        request.requestCancelledMessage = requestCancelMessage
        request.type = .post
        request.form = form
        let response = CSAFResponse(self, request)
        let queryString = buildQueryString(from: completeParams)
        let urlWithQuery = service + "?" + queryString
        manager.post(urlWithQuery, parameters: nil,
                     headers: nil, constructingBodyWith: form,
                     progress: response.onProgress, success: response.onSuccess,
                     failure: response.onFailure)
        return request
    }

    open func post<Data: CSServerData>(
        service: String, data: Data,
        params: [(String, Any?)] = []
    ) -> CSResponse<Data> {
        let request = CSResponse(url, service, data, createParams(params))
        request.requestCancelledMessage = requestCancelMessage
        request.type = .post
        let response = CSAFResponse(self, request)
        execute(request, response)
        return request
    }

    private func createParams(_ params: [(String, Any?)]) -> [(String, Any?)] {
        var newParams: [(String, Any?)] = [
            ("version", "IOS \(Bundle.shortVersion) \(Bundle.build)")
        ]
        newParams.add(array: defaultParams)
        newParams.add(array: params)
        return newParams
    }

    func execute<Data: CSServerData>(
        _ request: CSResponse<Data>, _ response: CSAFResponse<Data>
    ) {
        let queryString = buildQueryString(from: request.params)
        let urlWithQuery = request.service + "?" + queryString
        if request.type == .get {
            manager.get(urlWithQuery, parameters:nil, headers: nil,
                        progress: response.onProgress, success: response.onSuccess,
                        failure: response.onFailure)
        } else {
            if request.form.notNil {
                manager.post(urlWithQuery, parameters: nil, headers: nil,
                             constructingBodyWith: request.form!, progress: response.onProgress,
                             success: response.onSuccess, failure: response.onFailure)
            } else {
                manager.post(urlWithQuery, parameters: nil, headers: nil,
                             progress: response.onProgress, success: response.onSuccess,
                             failure: response.onFailure)
            }
        }
    }
}

func buildQueryString(from params: [(String, Any?)]) -> String {
    var queryString = ""
    for (key, value) in params {
        if let value = value {
            // Ensure that value is a string or convert it to a string if it's not nil
            queryString += "\(key)=\(value)&"
        }
    }
    // Remove trailing '&' if any
    if queryString.hasSuffix("&") {
        queryString = String(queryString.dropLast())
    }
    return queryString
}

public extension AFMultipartFormData {
    func appendUnicode(parts: [String: String]) {
        logInfo(parts.asJson?.substring(to: 100))
        for (key, value) in parts {
            appendPart(withForm: value.data(using: .unicode)!, name: key)
        }
    }

    func appendUTF8(parts: [(String, Any?)]) {
        var partsArray = [String: Any?]()
        parts.forEach { key, value in partsArray[key] = value }
        appendUTF8(parts: partsArray)
    }

    
    func appendUTF8(parts: [String: Any?]) {
        logInfo(parts.asJson?.substring(to: 100))
        for (key, value) in parts {
            appendPart(withForm: stringify(value).data(using: .utf8)!, name: key)
        }
    }

    func appendImage(parts: [UIImage]) {
        logInfo(parts)
        for index in 0 ..< parts.count {
            appendPart(withFileData: parts[index].jpegData(compressionQuality: 0.8)!,
                       name: "images[\(index)]", fileName: "mobileUpload.jpg", mimeType: "image/jpeg")
        }
    }
}

class CSAFResponse<ServerData: CSServerData>: NSObject {
    let client: CSAFClient
    let request: CSResponse<ServerData>
    var retryCount = 0

    init(_ client: CSAFClient, _ response: CSResponse<ServerData>) {
        self.client = client
        request = response
    }

    func onProgress(_ progress: Progress) {
        request.setProgress(progress.fractionCompleted)
    }

    func onSuccess(_ task: URLSessionDataTask, _ data: Any?) {
        handleResponse(task, data as? Data, error: nil)
    }

    func onFailure(_ task: URLSessionDataTask?, _ error: Error) {
        handleResponse(task, NSError.cast(error).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data, error: NSError.cast(error))
    }

    func handleResponse(_ task: URLSessionDataTask?, _ data: Data?, error: NSError?) {
        logUrl(task)
        let content = data.notNil ? String(data: data!, encoding: .utf8)! : ""
        logInfo(content)
        request.data!.loadContent(content)
        if error.notNil && request.data!.isEmpty {
            onHandleResponseError(task?.response, error!, content)
        } else if request.data!.success {
            request.success(request.data!)
        } else {
            onRequestFailed()
        }
    }

    func logUrl(_ task: URLSessionDataTask?) {
        let taskRequest = task?.currentRequest
        logInfo("from \(taskRequest?.url.asString)")
        let requestUrl = "\(request.url)\(request.service)"
        if requestUrl != taskRequest?.url?.absoluteString {
            logInfo("for \(requestUrl)")
        }
    }

    func onHandleResponseError(_ httpResponse: URLResponse?, _ error: NSError, _ content: String) {
        logWarn("Failed \(String(describing: httpResponse)) \(error.code) \(error.localizedDescription) \(content)")
        // Sometimes reciving code -999 canceled
        if error.code == -999 && retryCount < 3 {
            retryCount += 1
            logInfo("-999 Zruseno Retrying..." + httpResponse.asString)
            client.execute(request, self)
        } else {
            request.failed(message: error.localizedDescription)
        }
    }

    func onRequestFailed() {
        if let message = request.data!.message {
            request.failed(message: message)
        } else {
            request.failed(message: client.requestFailMessage)
        }
    }
}
