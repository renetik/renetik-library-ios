//
// Created by Rene Dohan on 3/15/20.
//

import Foundation
import RenetikObjc

public class CSArray<Type>: CSObject {
    private let array = NSMutableArray()

    var isEmpty: Bool { array.empty }

    func add(_ value: Type) -> Type { array.add(value); return value }

    func remove(_ response: Type) -> Self { array.remove(response); return self }

    func forEach(_ function: (Type) -> Void) -> Self {
        array.forEach { element in function(element as! Type) }
        return self
    }
}
