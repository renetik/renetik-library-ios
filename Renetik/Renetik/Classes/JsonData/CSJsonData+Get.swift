//
// Created by Rene Dohan on 12/4/19.
// Copyright (c) 2019 Bowbook. All rights reserved.
//

import Renetik

public extension CSJsonData {
    func getString(_ key: String) -> String? { data[key]??.get { $0.asString } }

    func getBoolean(_ key: String) -> Bool? { getString(key)?.boolValue }

    func getDouble(_ key: String) -> Double? { getString(key)?.doubleValue }

    func getInt(_ key: String) -> Int? { getString(key)?.intValue }

    func getList<T>(_ key: String) -> [T]? { data[key] as? [T] }
}
