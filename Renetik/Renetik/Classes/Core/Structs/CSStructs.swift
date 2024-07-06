//
// Created by Rene Dohan on 3/29/20.
//

import Foundation
import UIKit

public struct CSImageAction {
    public let image: UIImage, function: Func

    public init(_ image: UIImage, _ function: @escaping Func) {
        self.image = image
        self.function = function
    }
}

public struct CSTextAction {
    public let title: String, function: Func

    public init(_ title: String, _ function: @escaping Func) {
        self.title = title
        self.function = function
    }
}
