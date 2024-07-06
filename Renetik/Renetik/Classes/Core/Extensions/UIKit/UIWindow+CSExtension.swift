//
// Created by Rene Dohan on 3/12/20.
//

import Foundation
import UIKit

public extension UIWindow {
    class func construct(_ controller: UIViewController) -> Self {
        let window: Self = construct()
        window.rootViewController = controller
        window.makeKeyAndVisible()
        return window
    }

    class var window: UIWindow { delegate.window! }
    class var safeWidth: CGFloat { window.width - (window.safeAreaInsets.left + window.safeAreaInsets.right) }
    class var safeHeight: CGFloat { window.height - (window.safeAreaInsets.top + window.safeAreaInsets.bottom) }

    func show(root controller: UIViewController) -> Self {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = controller
            UIView.setAnimationsEnabled(oldState)
        })
        return self
    }
}
