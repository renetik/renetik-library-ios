//
//  CGFloat+CSExtension.swift
//  Renetik
//
//  Created by Rene Dohan on 4/12/19.
//

import CoreGraphics

public extension CGFloat { // TODO: move to CoreGraphics
    func plus(_ value: Int) -> CGFloat { self + CGFloat(value) }

    func multiply(_ value: Int) -> CGFloat { self * CGFloat(value) }

    var unsigned: CGFloat { self >= 0 ? self : 0 }

    // in the range 0 to 1
    static func random() -> CGFloat { CGFloat(arc4random()) / CGFloat(UInt32.max) }
}
