//
// Created by Rene Dohan on 1/1/20.
// Copyright (c) 2020 Renetik. All rights reserved.
//

import Alamofire
import Foundation
import Renetik
import RenetikObjc

public extension URLRequest {
    func clearCache(urlCache: URLCache = URLCache.shared) {
        let cachedResponse = urlCache.cachedResponse(for: self)!
        let httpResponse = cachedResponse.response as! HTTPURLResponse
        var headers = httpResponse.allHeaderFields as! [String: String]
        CSAlamofireCache.canUseCacheControl ? headers.addCacheControlField(maxAge: 0, isPrivate: false)
            : headers.addCacheExpiresField(maxAge: 0)
        HTTPURLResponse(url: httpResponse.url!, statusCode: httpResponse.statusCode,
                        httpVersion: CSAlamofireCache.HTTPVersion, headerFields: headers)?.then { response in
            urlCache.storeCachedResponse(CachedURLResponse(response: response, data: cachedResponse.data,
                                                           userInfo: ["framework": CSAlamofireCache.frameworkName],
                                                           storagePolicy: URLCache.StoragePolicy.allowed), for: self)
        }
    }
}
