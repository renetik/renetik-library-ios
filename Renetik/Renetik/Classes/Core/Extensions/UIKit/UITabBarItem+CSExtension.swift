//
// Created by Rene Dohan on 9/22/19.
//

import Foundation

public extension UITabBarItem {
    convenience init(title: String, image: UIImage?) {
        self.init(title: title, image: image, tag: 0)
    }
}
