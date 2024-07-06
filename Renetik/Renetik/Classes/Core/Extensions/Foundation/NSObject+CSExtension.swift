//
// Created by Rene Dohan on 1/31/20.
//

import Foundation
import RenetikObjc

public extension NSObject {
//    @objc class func construct() -> Self {
//        Self()
//    }

    //    var eventChangeProperty: CSEvent<Void> { extensionProperty("eventChange") { CSEvent<Void>() } }
    func extensionProperty<Type>(_ id: String, _ onCreate: () -> Type) -> Type {
        var dict = propertyDictionary() as! [String: Any]
        var instance = dict[id] as! Type?
        instance.isNil {
            instance = onCreate()
            dict[id] = instance
        }
        return instance!
    }
}
