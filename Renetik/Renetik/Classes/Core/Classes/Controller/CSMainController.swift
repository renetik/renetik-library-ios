//
// Created by Rene Dohan on 12/17/19.
//

import RenetikObjc
import UIKit

open class CSMainController: CSViewController {
    public var parentMainController: CSMainController? = nil
    private var childMainControllers = [CSMainController]()
    private var menuItems = [CSMenuHeader]()
    private lazy var menuDialog = CSAlertDialogController(in: self)

    override open func onViewDidLayoutFirstTime() {
        super.onViewDidLayoutFirstTime()
        if isTopController { updateBarItemsAndMenu() }
    }

    override open func onViewWillAppearLater() {
        super.onViewWillAppearLater()
        if isTopController { updateBarItemsAndMenu() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuDialog.hideDialog()
    }

    public var isTopController: Bool { parent is UINavigationController || parentMainController == nil }

    public var isChildController: Bool { !isTopController }

    public func updateBarItemsAndMenu(animated: Bool = false) {
        if isChildController {
            parentMainController?.updateBarItemsAndMenu(animated: animated)
            return
        }
        var menu = [CSMenuHeader]()
        onPrepare(menu: &menu)
        let actionItems = createActionBarItems(from: &menu)
        let barMenuItem = onCreate(menu: menu)
        var barItems = [UIBarButtonItem]()
        if barMenuItem != nil { barItems.add(barMenuItem!) }
        barItems.add(array: actionItems)
        onPrepareRightBarButton(items: &barItems)
        navigationItem.rightBarButtonItems = barItems
        navigationItem.setLeftBarButton(onPrepareLeftBarItem(), animated: animated)
    }

    func onPrepare(menu: inout [CSMenuHeader]) {
        for menuHeader in menuItems {
            if menuHeader.isVisible { menu.add(menuHeader) }
        }
        for controller in childMainControllers {
            if controller.isShowing { controller.onPrepare(menu: &menu) }
        }
    }

    func createActionBarItems(from menu: inout [CSMenuHeader]) -> [UIBarButtonItem] {
        var array: [UIBarButtonItem] = []
        if menu.first?.isDisplayedAsItem == true {
            array.add(menu.first!.items.first!.createButtonItem())
            menu.removeFirst()
        }
        if menu.first?.isDisplayedAsItem == true {
            array.add(menu.first!.items.first!.createButtonItem())
            menu.removeFirst()
        }
        if menu.first?.isDisplayedAsItem == true {
            array.add(menu.first!.items.first!.createButtonItem())
            menu.removeFirst()
        }
        return array.reversed()
    }

    func onCreate(menu: [CSMenuHeader]) -> UIBarButtonItem? {
        if menu.isEmpty { return nil }
        var actions = [CSDialogAction]()
        for header in menu {
            let item = header.items.first!
            actions.add(CSDialogAction(title: item.title!) { item.action!(item) })
        }
        return UIBarButtonItem(image: CSMenuItem.menuImage) { item in
            self.menuDialog.show(actions: actions, from: item)
        }
    }

    open func onPrepareRightBarButton(items _: inout [UIBarButtonItem]) {}

    override public func addChild(_ controller: UIViewController) {
        super.addChild(controller)
        (controller as? CSMainController).notNil { addChildMain(controller: $0) }
    }

    @discardableResult
    override public func dismissChild(controller: UIViewController) -> UIViewController {
        super.dismissChild(controller: controller)
        (controller as? CSMainController).then { controller in childMainControllers.remove(controller) }
        return controller
    }

    public func setChildMain(controllers: [CSMainController]) -> [CSMainController] {
        childMainControllers.removeAll()
        addChildMain(controllers: controllers)
        return childMainControllers
    }

    public func addChildMain(controllers: [CSMainController]) -> [CSMainController] {
        for controller in controllers {
            addChildMain(controller: controller)
        }
        return childMainControllers
    }

    public func addChildMain(controller: CSMainController) {
        childMainControllers.add(controller)
        controller.parentMainController = self
    }

    public func removeChildMain(controllers: [CSMainController]) -> Self {
        for controller in controllers {
            removeChildMain(controller: controller)
        }
        return self
    }

    public func removeChildMain(controller: CSMainController) {
        dismissChild(controller: controller)
    }

    open func onPrepareLeftBarItem() -> UIBarButtonItem? {
        for controller in childMainControllers {
            if controller.isShowing { return controller.onPrepareLeftBarItem() }
        }
        return nil
    }

    @discardableResult
    public func show(in parent: CSMainController) -> Self {
        let transition = CATransition()
        transition.duration = 0.15
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromBottom
        view.layer.add(transition, forKey: nil)
        parent.showChild(controller: self).view.matchParent()
        return self
    }

    @discardableResult
    open func hideIn() -> Self {
        isShowing = false
        UIView.animate(withDuration: 0.5,
                       animations: { self.view.bottom = -5 },
                       completion: { _ in
                           self.view.hide()
                           self.parentMainController?.dismissChild(controller: self)
                       })
        return self
    }

    @discardableResult
    public func menuAdd(header title: String = "") -> CSMenuHeader {
        menuItems.add(CSMenuHeader(by: self, index: menuItems.count, title: title))
    }
}
