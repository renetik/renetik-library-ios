//
// Created by Rene Dohan on 1/1/20.
// Copyright (c) 2020 Renetik. All rights reserved.
//

import Foundation

public enum CSAlamofireCache {
    public static var HTTPVersion = "HTTP/1.1"
    static var canUseCacheControl: Bool { !HTTPVersion.contains("1.0") }
    static let frameworkName = "RenetikAlamofireCache"
    static let refreshCacheKey = "refreshCache"
    static let refreshCacheValueRefresh = "refreshCache"
    static let refreshCacheValueUse = "useCache"
}

extension Dictionary where Key == String, Value == String {
    mutating func addCacheControlField(maxAge: TimeInterval, isPrivate: Bool) {
        // TODO: check format of result string should be just number without punctuation
        var cacheValue = "max-age=\(maxAge)"
        if isPrivate { cacheValue += ",private" }
        self["Cache-Control"] = cacheValue
    }

    mutating func addCacheExpiresField(maxAge: TimeInterval) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: self["Date"]!)!
        let expireDate = Date(timeInterval: maxAge, since: date)
        let cacheValue = formatter.string(from: expireDate)
        self["Expires"] = cacheValue
    }
}
