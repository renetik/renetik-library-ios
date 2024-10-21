//
// Created by Rene Dohan on 12/19/19.
//

import Renetik
import RenetikObjc
import UIKit

open class CSViewController: UIViewController {
    public let eventOrientationChanging: CSEvent<Void> = event()
    public let eventOrientationChanged: CSEvent<Void> = event()
    public let eventDismissing: CSEvent<Void> = event()
    public let eventDidAppear: CSEvent<Void> = event()
    public let eventDidLayoutFirstTime: CSEvent<Void> = event()
    public let eventWillAppearFirstTime: CSEvent<Void> = event()
    public let eventDidAppearFirstTime: CSEvent<Void> = event()

    public private(set) var isAppearing = false
    public var isShowing = false { didSet { if isShowing != oldValue { onShowingChanged() } } }
    public var isVisible: Bool { isAppearing && isShowing }

    private var isDidLayoutSubviews = false
    private var isOnViewWillAppearFirstTime = false
    private var isOnViewDidAppearFirstTime = false
    private var notificationCenterObservers: [NSObjectProtocol] = []
    private var eventRegistrations = [CSEventRegistration]()
    private var isShouldAutorotate: Bool? = nil
    private let layoutFunctions: CSEvent<Void> = event()

    public private(set) var controllerInNavigation: UIViewController?

    @discardableResult
    open func constructAsViewLess(in parent: UIViewController) -> Self {
        construct(parent)
        later {
            parent.showChild(controller: self)
            self.view.size(1).isUserInteractionEnabled = false
        }
        isShowing = true
        return self
    }

    @discardableResult
    open func construct(_ parent: UIViewController) -> Self {
        if let parent = parent as? CSViewController {
            register(event: parent.eventDismissing.invokeOnce(listener: onViewDismissing))
        }
        return self
    }

    // We need some size otherwise viewDidLayoutSubviews not called in some cases especially in constructAsViewLess
    override open func loadView() { view = UIControl.construct().defaultSize() }

    override open func viewDidLoad() {
        super.viewDidLoad()
//        logInfo("viewDidLoad \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        onViewDidLoad()
    }

    open func onViewDidLoad() {}

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateControllerInNavigation()
//        logInfo("viewWillAppear \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        onViewWillAppear()
        if !isOnViewWillAppearFirstTime {
            isOnViewWillAppearFirstTime = true
            onViewWillAppearFirstTime()
        } else {
            onViewWillAppearLater()
        }
    }

    open func onViewWillAppear() {}

    open func onViewWillAppearFirstTime() { eventWillAppearFirstTime.fire() }

    open func onViewWillAppearLater() {}

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateControllerInNavigation()
//        logInfo("viewDidLayoutSubviews \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        if !isDidLayoutSubviews {
            isDidLayoutSubviews = true
            onViewDidLayoutFirstTime()
            onCreateLayout()
            onLayoutCreated()
            eventDidLayoutFirstTime.fire()
        } else {
            onUpdateLayout()
        }
        runLayoutFunctions()
        onViewDidLayout()
    }

    open func onViewDidLayoutFirstTime() {}

    open func onCreateLayout() {}

    open func onLayoutCreated() {}

    open func onUpdateLayout() {}

    open func onViewDidLayout() {}

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        logInfo("viewDidAppear \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        isAppearing = true
        onViewDidAppear()
        if !isOnViewDidAppearFirstTime {
            isOnViewDidAppearFirstTime = true
            onViewDidAppearFirstTime()
        } else {
            onViewDidAppearFromPresentedController()
        }
    }

    open func onViewDidAppear() { eventDidAppear.fire() }

    open func onViewDidAppearFirstTime() { eventDidAppearFirstTime.fire() }

    // TODO: this is probably called also in different situations so has wrong name
    open func onViewDidAppearFromPresentedController() {}

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        logInfo("viewWillDisappear \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        onViewWillDisappear()
        //    if (self.navigationController.previous == self.controllerInNavigation) self.onViewPushedOver;
    }

    open func onViewWillDisappear() {}

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        logInfo("viewDidDisappear \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        if !isAppearing { return }
        isAppearing = false
        onViewDidDisappear()
        if let controllerInNavigation = controllerInNavigation {
            if  isBeingDismissed || !navigation.viewControllers.contains(controllerInNavigation) {
                onViewDismissing()
            } else if navigation.previous == controllerInNavigation {
                onViewPushedOver()
            }
        }
    }

    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
//        if parent.isNil {
//            logInfo("didMove(toParent:nil \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
//        }
    }

    open func onViewDidDisappear() {}

    open func onViewPushedOver() {
//        logInfo("onViewPushedOver \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
    }

    open func onViewDismissing() {
//        logInfo("onViewDismissing \(self) controllerInNavigation:\(controllerInNavigation) isAppearing:\(isAppearing) isShowing:\(isShowing)")
        eventRegistrations.each { $0.cancel() }
        notificationCenterObservers.each { NotificationCenter.remove(observer: $0) }
        eventDismissing.fire()
    }

    private func onShowingChanged() {
        onViewVisibilityChanged(isShowing)
        if isShowing { onViewShowing() } else { onViewHiding() }
    }

    open func onViewVisibilityChanged(_: Bool) {}

    open func onViewShowing() {}

    open func onViewHiding() {}

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        eventOrientationChanging.fire()
        onViewWillTransition(to: size, coordinator)
        coordinator.onCompletion { context in
            self.onViewDidTransition(to: size, context)
            self.eventOrientationChanged.fire()
        }
    }

    open func onViewWillTransition(to _: CGSize, _: UIViewControllerTransitionCoordinator) {}

    open func onViewDidTransition(to _: CGSize, _: UIViewControllerTransitionCoordinatorContext) {}

    public func observe(notification name: NSNotification.Name, callback: @escaping (Notification) -> Void) {
        notificationCenterObservers.add(NotificationCenter.add(observer: name, using: callback))
    }

    @discardableResult
    public func register<T>(event registration: CSEventListener<T>) -> CSEventListener<T> {
        eventRegistrations.add(registration).cast()
    }

    public func cancel<T>(event registration: CSEventListener<T>) {
        eventRegistrations.remove(registration)?.cancel()
    }

    override open var shouldAutorotate: Bool {
        if isShouldAutorotate.notNil { return isShouldAutorotate! }
        return super.shouldAutorotate
    }

    public func clearShouldAutorotate() { isShouldAutorotate = nil }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
            if previousTraitCollection?.isDarkMode != isDarkMode { onDisplayChangedTo(darkMode: isDarkMode) }
        }
    }

    open func onDisplayChangedTo(darkMode _: Bool) {}

    public func layout(function: @escaping Func) {
        layoutFunctions.invoke(listener: function)
        function()
    }

    @discardableResult
    public func layout<View: UIView>(_ view: View, function: @escaping (View) -> Void) -> View {
        layoutFunctions.invoke { function(view) }
        function(view)
        return view
    }

    public func runLayoutFunctions() {
        layoutFunctions.fire()
    }

    func updateControllerInNavigation() {
        if controllerInNavigation.isNil { controllerInNavigation = findControllerInNavigation() }
    }
}
