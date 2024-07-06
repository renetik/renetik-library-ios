//
//  Created by Rene on 11/26/18.
//

import RenetikObjc
import UIKit

public extension UIView {
    @discardableResult
    func add<View: UIView>(view: View, _ apply: ((View) -> Void)? = nil) -> View {
        addSubview(view)
        apply?(view)
        return view
    }

    @discardableResult
    func add<View: UIView>(_ view: View) -> View {
        addSubview(view)
        return view
    }

    @discardableResult
    func add(all views: UIView...) -> Self {
        views.forEach { view in add(view) }
        return self
    }

    @discardableResult
    func add(_ view: UIView, index: Int) -> UIView {
        insertSubview(view, at: index)
        return view
    }

    @discardableResult
    func set(_ view: UIView, index: Int) -> UIView {
        subviews.at(index)?.removeFromSuperview()
        return add(view, index: index)
    }

    func findPreviousVisible(of view: UIView) -> UIView? {
        if subviews.index(of: view).isNil {
            fatalError()
        }
        var index = subviews.index(of: view)! - 1
        while index >= 0 {
            let view = subviews[index]
            if view.isVisible { return view }
            index -= 1
        }
        return nil
    }

    func findLastSubviewOf(type someType: AnyClass) -> UIView? {
        var index = subviews.count - 1
        while index >= 0 {
            let subView = subviews[index]
            if type(of: subView) === someType { return subView }
            index -= 1
        }
        return nil
    }

    @discardableResult
    func clearSubviews() -> Self { invoke { subviews.each { $0.removeFromSuperview() } } }

    @discardableResult
    func removeAllSubviews() -> Self { clearSubviews() }

    var isEmpty: Bool { subviews.isEmpty }

    @discardableResult
    func horizontalGrid<View: UIView>(add view: View, margin: CGFloat = 0, columns: Int = 1) -> View {
        add(view: view).alignHorizontalGrid(margin: margin, columns: columns)
    }

    @discardableResult
    func verticalGrid<View: UIView>(add view: View, margin: CGFloat = 0, rows: Int = 1) -> View {
        add(view: view).alignVerticalGrid(margin: margin, rows: rows)
    }

    @discardableResult
    func addBottomSeparator(height: CGFloat = 0.5, color: UIColor = .darkGray) -> UIView {
        add(UIView.construct()).height(height).from(bottom: 0).matchParentWidth()
            .flexibleTop().fixedBottom().background(color)
    }
}
