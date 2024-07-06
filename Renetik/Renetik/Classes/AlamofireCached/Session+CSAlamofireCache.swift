//
// Created by Rene Dohan on 1/1/20.
// Copyright (c) 2020 Renetik. All rights reserved.
//

import Alamofire
import CoreFoundation
import Foundation
import Renetik
import RenetikObjc

public extension Session {
    @discardableResult
    func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil,
                 refreshCache: Bool = false) -> DataRequest
    {
        let headers = (method == .get && refreshCache) ? addCacheControl(to: headers) : headers
        return request(url, method: method, parameters: parameters,
                       encoding: encoding, headers: headers, interceptor: nil)
    }

    private func addCacheControl(to headers: HTTPHeaders?) -> HTTPHeaders {
        var newHeaders = headers.notNil ? headers! : HTTPHeaders()
        CSAlamofireCache.canUseCacheControl ? (newHeaders["Cache-Control"] = "no-cache")
            : (newHeaders["Pragma"] = "no-cache")
        newHeaders[CSAlamofireCache.refreshCacheKey] = CSAlamofireCache.refreshCacheValueRefresh
        return newHeaders
    }
}
