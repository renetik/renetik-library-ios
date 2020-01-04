//
// Created by Rene Dohan on 12/28/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Foundation
import Renetik
import RenetikObjc
import Alamofire

let INVALID_RESPONSE = "Invalid response from client"
let APPLICATION_ERROR = "Application error or invalid data"

public class CSAlamofireClient: CSObject {

    private let url: String
    private var host: String { url.remove("https://").remove("http://") }
    private var disabledTrustSecurity: Bool
    private var defaultParams: Dictionary<String, String> = [:]
    public var requestFailMessage = "Request failed"
    public var requestCancelMessage = "Request cancelled"

    public init(url: String, disabledTrustSecurity: Bool = false) {
        self.url = url
        self.disabledTrustSecurity = disabledTrustSecurity
        super.init()
    }

    private lazy var manager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let sessionDelegate = SessionDelegate()
        return Session(configuration: configuration, delegate: sessionDelegate,
                serverTrustManager: serverTrustManager)
    }()

    private var serverTrustManager: ServerTrustManager? {
        disabledTrustSecurity ? ServerTrustManager(evaluators: [host: DisabledEvaluator()]) : nil
    }

    public func addDefault(params: Dictionary<String, String>) {
        defaultParams.add(params)
    }

    public func clearDefaultParams() {
        defaultParams.removeAll()
    }

    public func acceptable(contentTypes: Array<String>) {
//        manager.responseSerializer.acceptableContentTypes = Set<String>(contentTypes)
    }

    public func basicAuthentication(username: String, password: String) {
//        manager.requestSerializer
//                .setAuthorizationHeaderFieldWithUsername(username, password: password)
    }

    public func get<DataType: CSServerJsonData>(_ operation: CSOperation<DataType>?, service: String,
                                                data: DataType, params: [String: String] = [:]) -> CSProcess<DataType> {
        CSProcess("\(url)/\(service)", data).also { process in
//            if (operation?.isCached.isFalse) builder.doNotCacheResponse()
//            operation?.expireMinutes.notNull { minutes ->
//                    builder.setMaxStaleCacheControl(minutes * CSConstants.MINUTE, TimeUnit.MILLISECONDS)
//            }
//            if (operation?.isRefresh.isTrue) builder.responseOnlyFromNetwork
//        else if (!application.isNetworkConnected && operation?.isCached.isTrue
//        || operation?.isJustUseCache.isTrue) {
//        builder.responseOnlyIfCached //TODO Return cached data directly maybe by setting maxAge to int max value
//        }
            let request = manager.request(url: process.url!, method: .get, parameters: params,
                    encoding: URLEncoding.default, refreshCache: (operation?.isRefresh).isTrue)
//            request.validate(statusCode: 200..<300).validate(contentType: ["application/json"])
            operation?.expireMinutes.notNil { minutes in request.cache(manager, maxAge: Double(minutes * 60)) }
            request.responseString(encoding: nil,
                    completionHandler: { response in self.onResponseDone(response: response, process: process) },
                    autoClearCache: (operation?.isCached).isFalse)
        }
    }

    public func post(service: String, params: [String: String] = [:]) -> CSProcess<CSServerJsonData> {
        post(service: service, data: CSServerJsonData(), params: params)
    }

    public func post<DataType: CSServerJsonData>(service: String, data: DataType,
                                                 params: [String: String] = [:]) -> CSProcess<DataType> {
        CSProcess("\(url)/\(service)", data).also { process in
            let request = manager.request(process.url!, method: .post, parameters: params)
//            request.validate(statusCode: 200..<300).validate(contentType: ["application/json"])
            request.responseString(encoding: nil,
                    completionHandler: { response in self.onResponseDone(response: response, process: process) })
        }
    }

    private func onResponseDone<DataType: CSServerJsonData>(response: AFDataResponse<String>,
                                                            process: CSProcess<DataType>) {
        response.error.notNil { error in onResponse(error: error, message: error.errorDescription, process) }
                .elseDo { onResponse(content: response.value, process) }
    }

    private func onResponse<DataType: CSServerJsonData>(content: String?, _ process: CSProcess<DataType>) {
        logInfo("\(process.url!) \(content ?? "nil")")
        let jsonValue = content?.asNSString.jsonValue()
        (jsonValue as? [String: CSAny?]).notNil { it in process.data!.load(data: it) }
                .elseDo { onResponse(error: nil, message: INVALID_RESPONSE, process) }
        if process.data!.success { process.success() } else { onResponse(error: nil, message: process.data!.message ?? "No Message", process) }
    }

    private func onResponse<DataType: CSServerJsonData>(error: AFError?, message: String?,
                                                        _ process: CSProcess<DataType>) {
        invalidate(url: process.url!)
        process.failed(error, message: message)
    }

    // TODO: Invalidate url in cache if request failed maybe already implemented in UrlCacheExtensions
    private func invalidate(url: String) {}
}