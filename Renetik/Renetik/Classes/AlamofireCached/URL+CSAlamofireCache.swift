//
// Created by Rene Dohan on 1/1/20.
// Copyright (c) 2020 Renetik. All rights reserved.
//

import Alamofire
import Foundation
import Renetik
import RenetikObjc

public extension URL {
    func clearCache(parameters: [String: Any]? = nil, headers: HTTPHeaders? = nil, urlCache: URLCache = URLCache.shared) {
        if var request = try? URLRequest(url: self, method: HTTPMethod.get, headers: headers) {
            request.cachePolicy = .reloadIgnoringLocalCacheData
            (try? URLEncoding().encode(request, with: parameters))?.clearCache(urlCache: urlCache)
        }
    }
}
