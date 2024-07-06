//
// Created by Rene Dohan on 3/14/20.
//

import Foundation

public protocol CSHasStyle {
    func styledLight()
    func styledDark()
}

// TODO: get dark or light from delegate probably where it can be changed by code but default goes from system
public extension CSHasStyle {
    @discardableResult
    func styled() -> Self {
        styledLight()
        return self
    }
}
