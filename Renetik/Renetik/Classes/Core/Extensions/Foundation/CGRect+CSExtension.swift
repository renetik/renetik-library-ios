//
// Created by Rene Dohan on 2/1/20.
//

import CoreGraphics

public extension CGRect { // TODO: move to CoreGraphics
    init(size: CGFloat) {
        self.init(width: size, height: size)
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(origin: .zero, size: CGSize(width: width, height: height))
    }

    var x: CGFloat { origin.x }
    var y: CGFloat { origin.y }
    var width: CGFloat {
        get { size.width }
        set { size.width = newValue }
    }

    var height: CGFloat {
        get { size.height }
        set { size.height = newValue }
    }
}
