//
//  Renetik
//
//  Created by Rene Dohan on 7/8/19.
//

import Renetik
import RenetikObjc
import UIKit

public extension UITabBar {
    class var imageSize: CGFloat { 30 }

    @discardableResult
    func items(_ items: [UITabBarItem]) -> Self { invoke { self.items = items } }

    @discardableResult
    func delegate(_ delegate: UITabBarDelegate) -> Self { invoke { self.delegate = delegate } }

    @discardableResult
    func selected(index: Int) -> Self { invoke { self.selectedIndex = index } }

    var selectedIndex: Int {
        get { selectedItem?.get { item in items!.index(of: item)! } ?? -1 }
        set { selectedItem = items![newValue] }
    }
}
