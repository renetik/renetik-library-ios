//
// Created by Rene Dohan on 10/29/20.
//

import UIKit

public extension UINavigationController {
    @discardableResult
    func popViewController() -> UIViewController? {
        (self as? CSNavigationController)?.popViewController(animated: true)
        ?? popViewController(animated: true)
    }

    var last: UIViewController? {
        viewControllers.last
    }

    var beforePrevious: UIViewController? {
        viewControllers.at(viewControllers.lastIndex - 2)
    }

    var previous: UIViewController? {
        viewControllers.at(viewControllers.lastIndex - 1)
    }

    var root: UIViewController? {
        viewControllers.first
    }

    @objc func push(asRoot newRoot: UIViewController) {
        (self as? CSNavigationController)?.setViewControllers([newRoot], animated: true)
        ?? setViewControllers([newRoot], animated: true)
    }
    
    @discardableResult
    func push(_ controller: UIViewController) -> UIViewController {
        (self as? CSNavigationController)?.pushViewController(controller, animated: true)
        ?? pushViewController(controller, animated: true)
        return controller
    }

    @discardableResult
    func push(fromTop controller: UIViewController) -> UIViewController {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromBottom
        view.layer.add(transition, forKey: nil)
        (self as? CSNavigationController)?.pushViewController(controller, animated: false)
        ?? pushViewController(controller, animated: false)
        return controller
    }

    func push(_ pushingController: UIViewController, keepLast keepLastCount: Int) {
        var toRemove = [UIViewController]()
        var count = keepLastCount
        for controller in self.viewControllers {
            if controller.isKind(of: type(of: pushingController)) {
                if count > 0 { count -= 1 } else { toRemove.add(controller) }
            }
        }
        var viewControllers: [UIViewController] = self.viewControllers
        toRemove.each { viewControllers.remove($0) }
        viewControllers.add(pushingController)
        (self as? CSNavigationController)?.setViewControllers(viewControllers, animated: true)
        ?? setViewControllers(viewControllers, animated: true)
    }

    func contains<T: UIViewController>(controllerType: T.Type) -> Bool {
        for controller in viewControllers {
            if controller.isKind(of: controllerType) {
                return true
            }
        }
        return false
    }

    func push(_ pushId: String, _ pushingController: UIViewController) {
        pushingController.propertyDictionary()["PushID"] = pushId

        var toRemove = [UIViewController]()
        for controller in viewControllers {
            toRemove.add(controller)
            if controller.propertyDictionary()["PushID"] as? String == pushId {
                var viewControllers = self.viewControllers
                toRemove.each { viewControllers.remove($0) }
                viewControllers.add(pushingController)
                (self as? CSNavigationController)?
                    .setViewControllers(viewControllers, animated: true)
                ?? setViewControllers(viewControllers, animated: true)
                return
            }
        }
        push(pushingController)
    }
}

