//
// Created by Rene Dohan on 2/21/20.
//

import UIKit

public extension UIEdgeInsets {
    var horizontalSize: CGFloat { left + right }

    var horizontal: (left: CGFloat, right: CGFloat) { (left: left, right: right) }

    var verticalSize: CGFloat { top + bottom }

    var vertical: (top: CGFloat, bottom: CGFloat) { (top: top, bottom: bottom) }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }

    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }

    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }

    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }

    init(left: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }

    init(_ inset: CGFloat) { self.init(horizontal: inset, vertical: inset) }
}
