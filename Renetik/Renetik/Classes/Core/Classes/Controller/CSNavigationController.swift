//
// Created by Rene Dohan on 12/22/19.
//

import RenetikObjc
import UIKit

public enum CSForcedOrientation: Int {
    case none
    case portrait
    case landscape
}

open class CSNavigationController: UINavigationController, UINavigationBarDelegate {
    private(set) var instance: CSNavigationController!
    private(set) var lastPopped: UIViewController?
    private var navigationBarDelegate: UINavigationBarDelegate?

    public func construct() -> Self { self }

    override open func viewDidLoad() {
        super.viewDidLoad()
        instance = self
        navigationBar.onClick { UIApplication.resignFirstResponder() }
    }

    @discardableResult
    open func pop() -> UIViewController? { super.popViewController(animated: true) }

    override open func popViewController(animated: Bool) -> UIViewController? {
        lastPopped = last
        return super.popViewController(animated: animated)
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        lastPopped = nil
        super.pushViewController(viewController, animated: animated)
    }

    override open func push(asRoot newRoot: UIViewController!) {
        lastPopped = nil
        super.push(asRoot: newRoot)
    }

    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        super.popToRootViewController(animated: animated)
    }

    override open func popToViewController(_ controller: UIViewController, animated: Bool) -> [UIViewController]? {
        lastPopped = controller
        return super.popToViewController(controller, animated: animated)
    }

    override open var shouldAutorotate: Bool {
        viewControllers.last?.shouldAutorotate ?? true
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if forcedOrientation != .none {
            if forcedOrientation == .portrait { return [.portrait, .portraitUpsideDown] }
            return .landscape
        }
        return viewControllers.last?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.all
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        viewControllers.last?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }

    private var forcedOrientation: CSForcedOrientation?
    private var orientationToReturnToFromForcedOrientation: UIDeviceOrientation?
    private var orientationDidChangeNotificationObserverToken: NSObjectProtocol?

    public func force(orientation: CSForcedOrientation) {
        forcedOrientation = orientation
        orientationToReturnToFromForcedOrientation = UIDeviceOrientation(rawValue: UIScreen.orientation.rawValue)
        if (forcedOrientation == .portrait || forcedOrientation == .none) && UIScreen.isLandscape {
            UIDevice.set(orientation: .portrait)
        } else if (forcedOrientation == .landscape || forcedOrientation == .none) && UIScreen.isPortrait {
            UIDevice.set(orientation: .landscapeLeft)
        }
        orientationDidChangeNotificationObserverToken =
            NotificationCenter.add(observer: UIDevice.orientationDidChangeNotification) { _ in
                self.orientationToReturnToFromForcedOrientation = UIDevice.current.orientation
                NotificationCenter.remove(observer: self.orientationDidChangeNotificationObserverToken)
            }
    }

    public func cancelForcedOrientation() {
        if orientationToReturnToFromForcedOrientation.isNil { return }
        forcedOrientation = .none
        NotificationCenter.remove(observer: orientationDidChangeNotificationObserverToken)
        UIDevice.set(orientation: orientationToReturnToFromForcedOrientation!)
    }
}
