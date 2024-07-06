//
// Created by Rene Dohan on 2/12/20.
//

import RenetikObjc
import UIKit

public extension UIApplication {
    class var window: UIWindow? { UIApplication.shared.windows.last }

    @objc class func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }

    class func open(url: String) {
        open(url: URL(string: url)!)
    }

    class func open(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    class var statusBarHeight: CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let height = min(statusBarSize.width, statusBarSize.height)
        return height
    }

    class var statusBarBottom: CGFloat {
        statusBarHeight
    }
}
