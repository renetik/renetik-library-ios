//
// Created by Rene Dohan on 3/12/20.
//

import UIKit

public extension UIColor {
    static let tint: UIColor = UIButton(type: .system).tintColor

    func add(alpha: CGFloat) -> UIColor { withAlphaComponent(alpha) }

    static func random() -> UIColor {
        UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
