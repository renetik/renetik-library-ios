//
// Created by Rene Dohan on 1/9/20.
//

import UIKit

public extension UITraitCollection {
    @available(iOS 12.0, *)
    var isDarkMode: Bool { userInterfaceStyle == .dark }
}
