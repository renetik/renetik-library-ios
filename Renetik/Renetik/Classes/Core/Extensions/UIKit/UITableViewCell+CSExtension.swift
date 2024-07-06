//
// Created by Rene Dohan on 1/22/20.
//

import UIKit

public extension UITableViewCell {
    @discardableResult
    override open func construct() -> Self {
        super.construct()
        selectedBackgroundView = UIView.construct(color: UIColor.clear)
        contentView.matchParent()
        return self
    }

    func setBackgroundViewColor(_ color: UIColor) {
        backgroundView = UIView.construct(color: color)
    }

    func setSelectedBackgroundColor(_ color: UIColor) {
        selectedBackgroundView = UIView.construct(color: color)
    }

    var cellView: UIView? { contentView.content }
}
