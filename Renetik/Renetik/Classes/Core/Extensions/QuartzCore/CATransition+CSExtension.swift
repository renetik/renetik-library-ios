//
// Created by Rene Dohan on 9/20/19.
//

import QuartzCore.CAAnimation

public extension CATransition {
    @discardableResult
    class func create(for view: UIView,
                      duration: CFTimeInterval = 0.5,
                      timing: CAMediaTimingFunctionName = .easeInEaseOut,
                      type: CATransitionType = .fade,
                      subtype: CATransitionSubtype? = nil) -> CATransition
    {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: timing)
        transition.type = type
        transition.subtype = subtype
        view.layer.add(transition, forKey: nil)
        return transition
    }
}
