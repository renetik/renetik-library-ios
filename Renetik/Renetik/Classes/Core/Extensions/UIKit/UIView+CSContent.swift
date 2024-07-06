//
// Created by Rene Dohan on 1/29/20.
//

import BlocksKit
import RenetikObjc
import UIKit

private var viewContentPropertyKey: UInt8 = 0

public extension UIView {
    var content: UIView? {
        get { getObject(&viewContentPropertyKey) as? UIView }
        set(view) {
            content?.removeFromSuperview()
            setWeak(&viewContentPropertyKey, view)
            view.notNil { add($0) }
        }
    }

    func content<View: UIView>(_ view: View) -> View { content = view; return view }

    class func withContent(_ view: UIView = UIView.construct()) -> Self {
        let container = construct(frame: view.frame)
        container.content(view).matchParent()
        return container
    }

    class func wrap(view: UIView) -> Self {
        let container = construct(frame: view.frame)
        let center = view.center
        let superview = view.superview
        let autoSize = view.autoresizingMask
        container.content(view).matchParent()
        superview?.add(container).center(center).autoresizingMask = autoSize
        container.backgroundColor = view.backgroundColor
        view.backgroundColor = UIColor.clear
        return container
    }

    class func wrap(view: UIView, padding: CGFloat) -> Self {
        let container = construct(width: view.width + padding * 2,
                                  height: view.height + padding * 2)
        let center = view.center
        let superview = view.superview
        let autoSize = view.autoresizingMask
        container.content(view).matchParent(margin: padding)
        superview?.add(container).center(center).autoresizingMask = autoSize
        container.backgroundColor = view.backgroundColor
        view.backgroundColor = UIColor.clear
        return container
    }

    func contentVertical(padding: CGFloat) -> Self {
        content!.from(top: padding).height(fromBottom: padding).flexibleWidth()
        return self
    }

    func contentHorizontal(padding: CGFloat) -> Self {
        content!.from(left: padding).width(fromRight: padding).flexibleHeight()
        return self
    }

//    func content(padding: CGFloat) -> Self {
//        contentHorizontal(padding: padding)
//        contentVertical(padding: padding)
//        return self
//    }
}
