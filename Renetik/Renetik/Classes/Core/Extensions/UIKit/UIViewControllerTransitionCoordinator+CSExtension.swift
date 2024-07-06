//
// Created by Rene Dohan on 1/19/20.
//

import UIKit

public extension UIViewControllerTransitionCoordinator {
    func onCompletion(_ function: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        animate(alongsideTransition: nil, completion: function)
    }
}
