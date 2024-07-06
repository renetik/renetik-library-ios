//
// Created by Rene Dohan on 12/18/19.
//

import Renetik
import RenetikObjc

public class CSMenuItem: CSObject {
    private let controller: CSMainController
    public var title: String? {
        didSet { updateMenu() }
    }

    public var systemItem: UIBarButtonItem.SystemItem? {
        didSet { updateMenu() }
    }

    public var image: UIImage? {
        didSet { updateMenu() }
    }

    public var tintColor: UIColor? {
        didSet { updateMenu() }
    }

    public var isVisible = true {
        didSet { updateMenu() }
    }

    var action: ((CSMenuItem) -> Void)?
    var view: UIView?
    var isNoActionItem = false
    var index = 0

    public init(by parent: CSMainController, title: String? = nil,
                systemItem: UIBarButtonItem.SystemItem? = nil,
                image: UIImage? = nil, action: ((CSMenuItem) -> Void)? = nil)
    {
        controller = parent
        self.title = title
        self.systemItem = systemItem
        self.image = image
        self.action = action
    }

    public init(by parent: CSMainController, view: UIView? = nil, action: ((CSMenuItem) -> Void)? = nil) {
        controller = parent
        self.view = view
        self.action = action
    }

    @discardableResult
    public func hide() -> Self {
        isVisible = false
        return self
    }

    @discardableResult
    public func show() -> Self {
        isVisible = true
        return self
    }

    public var hidden: Bool {
        get { !isVisible }
        set(value) { isVisible = !value }
    }

    private func updateMenu() {
        if !controller.isViewLoaded { return }
        (controller as? CSMainController).notNil { $0.updateBarItemsAndMenu() }.elseDo {
            (controller.parent as? CSMainController).notNil { $0.updateBarItemsAndMenu() }
                .elseDo { logError("CSMainController not found") }
        }
    }

    func createButtonItem() -> UIBarButtonItem {
        let barButtonItem = createBarButtonItem()
        barButtonItem.tintColor = tintColor
        return barButtonItem
    }

    private func createBarButtonItem() -> UIBarButtonItem {
        if systemItem.notNil { return UIBarButtonItem(item: systemItem!, onClick: onBarButtonClick) }
        if image.notNil { return UIBarButtonItem(image: image!, onClick: onBarButtonClick) }
        return UIBarButtonItem(title: title!, onClick: onBarButtonClick)
    }

    private var onBarButtonClick: (Any) -> Void { { _ in self.action!(self) } }

    @discardableResult
    func set(view: UIView) -> Self {
        self.view = view
        return self
    }

    @discardableResult
    public func noAction() -> Self {
        isNoActionItem = true
        return self
    }
}

public extension CSMenuItem {
    static var menuImage: UIImage = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 26, height: 26), _: false, _: 0)
        // Color Declarations
        let fillColor = UIColor.white
        // Frames
        let frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        // Bottom Bar Drawing
        let bottomBarPath = UIBezierPath(rect: CGRect(x: frame.minX + floor((frame.width - 16) * 0.50000 + 0.5),
                                                      y: frame.minY + floor((frame.height - 1) * 0.72000 + 0.5), width: 16, height: 1))
        fillColor.setFill()
        bottomBarPath.fill()
        // Middle Bar Drawing
        let middleBarPath = UIBezierPath(rect: CGRect(x: frame.minX + floor((frame.width - 16) * 0.50000 + 0.5),
                                                      y: frame.minY + floor((frame.height - 1) * 0.48000 + 0.5), width: 16, height: 1))
        fillColor.setFill()
        middleBarPath.fill()
        // Top Bar Drawing
        let topBarPath = UIBezierPath(rect: CGRect(x: frame.minX + floor((frame.width - 16) * 0.50000 + 0.5),
                                                   y: frame.minY + floor((frame.height - 1) * 0.24000 + 0.5), width: 16, height: 1))
        fillColor.setFill()
        topBarPath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }()
}
