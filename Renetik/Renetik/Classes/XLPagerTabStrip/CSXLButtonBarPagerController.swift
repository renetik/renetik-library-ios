//
// Created by Rene Dohan on 2/16/20.
//

import Foundation
import RenetikObjc
import UIKit
import XLPagerTabStrip

public typealias CSXLButtonBarPagerChildController = CSMainController & IndicatorInfoProvider

public class CSXLButtonBarPagerController: CSMainController, PagerTabStripIsProgressiveDelegate {
    public let pager = CSButtonBarPagerTabStripViewController()

    fileprivate var controllers = [CSXLButtonBarPagerChildController]()
    private var currentController: CSXLButtonBarPagerChildController { controllers[pager.currentIndex] }

    @discardableResult
    public func construct(by parent: CSMainController, controllers: [CSXLButtonBarPagerChildController]) -> Self {
        super.construct(parent)
        self.controllers = controllers
        parent.showChild(controller: self).view.matchParent()
        showChild(controller: pager.construct(self)).view.matchParent()
        addChildMain(controllers: controllers)
        return self
    }

    override public func onViewWillAppearFirstTime() {
        super.onViewWillAppearFirstTime()
        updateControllersVisible(at: pager.currentIndex, animated: false)
        pager.delegate = self
    }

    override public func onViewDidAppearFirstTime() {
        super.onViewDidAppearFirstTime()
        pager.reloadPagerTabStripView()
        pager.delegate = self
    }

    public func updateIndicator(for _: PagerTabStripViewController, fromIndex _: Int, toIndex _: Int) {
        updateControllersVisible(at: pager.currentIndex, animated: true)
    }

    public func updateIndicator(for _: PagerTabStripViewController, fromIndex _: Int, toIndex _: Int,
                                withProgressPercentage _: CGFloat, indexWasChanged: Bool)
    {
        if indexWasChanged { updateControllersVisible(at: pager.currentIndex, animated: false) }
    }

    func updateControllersVisible(at _: Int, animated: Bool) {
        for controller in controllers {
            if controller !== currentController { controller.isShowing = false }
        }
        currentController.isShowing = true
        updateBarItemsAndMenu(animated: animated)
    }

    public func load(controllers: [CSXLButtonBarPagerChildController]) {
        removeChildMain(controllers: self.controllers)
        self.controllers = controllers
        addChildMain(controllers: self.controllers)
        pager.reloadPagerTabStripView()
        updateControllersVisible(at: pager.currentIndex, animated: false)
    }

    public func add(controller: CSXLButtonBarPagerChildController) {
        controllers.add(controller)
        addChildMain(controller: controller)
        pager.reloadPagerTabStripView()
        updateControllersVisible(at: pager.currentIndex, animated: false)
    }

    override public func onViewDidTransition(to size: CGSize,
                                             _ context: UIViewControllerTransitionCoordinatorContext)
    {
        super.onViewDidTransition(to: size, context)
        pager.containerView.scrollTo(page: pager.currentIndex, of: controllers.count)
    }

    public func setBar(visible: Bool) {
        if visible {
            let buttonBarHeight = pager.settings.style.buttonBarHeight ?? 44
            pager.buttonBarView.height = buttonBarHeight
            pager.containerView.height(fromTop: buttonBarHeight)
        } else {
            pager.buttonBarView.height = 0
            pager.containerView.height(fromTop: 0)
        }
    }

    public var currentIndex: Int { pager.currentIndex }

    @discardableResult
    public func moveToController(index: Int) -> Self { invoke { self.pager.moveToViewController(at: index) } }

    @discardableResult
    public func moveTo(controller: UIViewController) -> Self { invoke { self.pager.moveTo(viewController: controller) } }
}

public class CSButtonBarPagerTabStripViewController: ButtonBarPagerTabStripViewController {
    var parentController: CSXLButtonBarPagerController!

    func construct(_ parent: CSXLButtonBarPagerController) -> Self {
        parentController = parent
        return self
    }

    override public func viewControllers(
        for _: PagerTabStripViewController) -> [UIViewController]
    {
        parentController.controllers
    }

    // PagerTabStripDelegate delegate was not called by super implementation
    override public func updateIndicator(for viewController: PagerTabStripViewController,
                                         fromIndex: Int, toIndex: Int)
    {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
        parentController.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
    }

    // PagerTabStripIsProgressiveDelegate delegate was not called by super implementation
    override public func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int,
                                         withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool)
    {
        if fromIndex == 0 && toIndex == 0 && progressPercentage == 1 && indexWasChanged == false { return }
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex,
                              withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        parentController.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex,
                                         withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
    }

    // Fixes overlapping of content by bezels on iphone x and similar
    override open func updateContent() {
        super.updateContent()
        for (index, childController) in parentController.controllers.enumerated() {
            childController.view.frame = CGRect(x: offsetForChild(at: index) + safeArea.left,
                                                y: 0, width: view.bounds.width - (view.safeAreaInsets.left + safeArea.right),
                                                height: containerView.bounds.height)
        }
    }
}
