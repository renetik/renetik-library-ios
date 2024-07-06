//
// Created by Rene Dohan on 6/12/20.
//

import Foundation

public class CSValueStore {
    public class func getString(key: String, default defaultValue: String = "") -> String {
        UserDefaults.load(key, defaultValue)
    }

    public class func save(key: String, value: String) { UserDefaults.save(key, value) }
}

public extension CSValueStore {
    class func getInt(key: String, default defaultValue: Int = 0) -> Int {
        getString(key: key, default: stringify(defaultValue)).intValue
    }

    class func save(key: String, value: Int) { save(key: key, value: stringify(value)) }
}
