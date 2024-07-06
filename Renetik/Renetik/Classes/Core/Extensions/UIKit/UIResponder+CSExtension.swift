//
// Created by Rene Dohan on 3/4/20.
//

import Foundation

public extension UIResponder {
    var safeArea: UIEdgeInsets { delegate.window!.safeAreaInsets }

    func invoke(animated: Bool, duration: TimeInterval = defaultAnimationTime, operation: @escaping Func) {
        if animated { UIView.animate(withDuration: duration, animations: operation) } else { operation() }
    }

    func invoke(animated: Bool, duration: TimeInterval = defaultAnimationTime,
                operation: @escaping Func, completion: @escaping Func)
    {
        if animated {
            UIView.animate(withDuration: duration, animations: operation, completion: { _ in completion() })
        } else {
            operation()
            completion()
        }
    }

    func animate(duration: TimeInterval = defaultAnimationTime, operation: @escaping Func) {
        UIView.animate(withDuration: duration, animations: operation)
    }
}
