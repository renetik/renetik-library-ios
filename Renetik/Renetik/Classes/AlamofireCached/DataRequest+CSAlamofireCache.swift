//
// Created by Rene Dohan on 1/1/20.
// Copyright (c) 2020 Renetik. All rights reserved.
//

import Alamofire
import CoreFoundation
import Foundation
import Renetik
import RenetikObjc

public extension DataRequest {
    func clearCache(dataRequest _: DataRequest, urlCache: URLCache = URLCache.shared) {
        request?.clearCache(urlCache: urlCache)
    }
}

public extension DataRequest {
    @discardableResult
    func cache(_ session: Session, maxAge: TimeInterval,
               isPrivate: Bool = false, ignoreServer: Bool = true) -> Self
    {
        if maxAge <= 0 { return self }
        let requestRefreshCache = request?.allHTTPHeaderFields?[CSAlamofireCache.refreshCacheKey]
        if requestRefreshCache.notNil && requestRefreshCache != CSAlamofireCache.refreshCacheValueRefresh {
            let cachedResponse = session.sessionConfiguration.urlCache?
                .cachedResponse(for: request!)?.response as? HTTPURLResponse
            if cachedResponse?.allHeaderFields[CSAlamofireCache.refreshCacheKey].asString
                == CSAlamofireCache.refreshCacheValueUse
            {
                return self
            }
        }
        let useServerButRefresh = !ignoreServer && requestRefreshCache == CSAlamofireCache.refreshCacheValueRefresh
        return response { data in
            if data.request?.httpMethod != "GET" {
                logInfo("Non-GET requests do not support caching!")
                return
            }
            if data.error != nil {
                logError(data.error!.localizedDescription)
                return
            }
            if let httpResponse = data.response {
                guard let newRequest = data.request else { return }
                guard let newData = data.data else { return }
                guard let newURL = httpResponse.url else { return }
                guard let urlCache = session.sessionConfiguration.urlCache else { return }
                var httpResponseHeaders = httpResponse.allHeaderFields as! [String: String]
                if CSAlamofireCache.canUseCacheControl {
                    let httpResponseCacheControl = httpResponseHeaders["Cache-Control"]
                    if httpResponseCacheControl == nil || httpResponseCacheControl.contains("no-cache") ||
                        httpResponseCacheControl.contains("no-store") || ignoreServer || useServerButRefresh
                    {
                        if ignoreServer {
                            if httpResponseHeaders["Vary"] != nil { httpResponseHeaders.remove(key: "Vary") } // http 1.1
                            if httpResponseHeaders["Pragma"] != nil { httpResponseHeaders.remove(key: "Pragma") }
                        }
                        httpResponseHeaders.addCacheControlField(maxAge: maxAge, isPrivate: isPrivate)
                    } else {
                        return
                    }
                } else {
                    if httpResponseHeaders["Expires"] == nil || ignoreServer || useServerButRefresh {
                        httpResponseHeaders.addCacheExpiresField(maxAge: maxAge)
                        if ignoreServer {
                            if httpResponseHeaders["Pragma"] != nil { httpResponseHeaders["Pragma"] = "cache" }
                            if httpResponseHeaders["Cache-Control"] != nil { httpResponseHeaders.remove(key: "Cache-Control") }
                        }
                    } else {
                        return
                    }
                }
                httpResponseHeaders[CSAlamofireCache.refreshCacheKey] = CSAlamofireCache.refreshCacheValueUse
                if let newResponse = HTTPURLResponse(url: newURL, statusCode: httpResponse.statusCode,
                                                     httpVersion: CSAlamofireCache.HTTPVersion, headerFields: httpResponseHeaders)
                {
                    let newCacheResponse = CachedURLResponse(response: newResponse, data: newData,
                                                             userInfo: ["framework": CSAlamofireCache.frameworkName],
                                                             storagePolicy: URLCache.StoragePolicy.allowed)
                    urlCache.storeCachedResponse(newCacheResponse, for: newRequest)
                }
            }
        }
    }

    @discardableResult
    func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue = .main, responseSerializer: T,
        completionHandler: @escaping (AFDataResponse<T.SerializedObject>) -> Void,
        autoClearCache: Bool
    ) -> Self {
        let myCompleteHandler: ((AFDataResponse<T.SerializedObject>) -> Void) = { dataResponse in
            if dataResponse.error != nil && autoClearCache { dataResponse.request?.clearCache() }
            completionHandler(dataResponse)
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: myCompleteHandler)
    }

    @discardableResult
    func responseData(queue: DispatchQueue = .main,
                      completionHandler: @escaping (AFDataResponse<Data>) -> Void, autoClearCache: Bool) -> Self
    {
        response(queue: queue, responseSerializer: DataResponseSerializer(),
                 completionHandler: completionHandler, autoClearCache: autoClearCache)
    }

    @discardableResult
    func responseString(queue: DispatchQueue = .main, encoding: String.Encoding? = nil,
                        completionHandler: @escaping (AFDataResponse<String>) -> Void, autoClearCache: Bool) -> Self
    {
        response(queue: queue, responseSerializer: StringResponseSerializer(encoding: encoding),
                 completionHandler: completionHandler, autoClearCache: autoClearCache)
    }

    @discardableResult
    func responseJSON(queue: DispatchQueue = .main, options: JSONSerialization.ReadingOptions = .allowFragments,
                      completionHandler: @escaping (AFDataResponse<Any>) -> Void, autoClearCache: Bool) -> Self
    {
        response(queue: queue, responseSerializer: JSONResponseSerializer(options: options),
                 completionHandler: completionHandler, autoClearCache: autoClearCache)
    }
}
