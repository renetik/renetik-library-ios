//
// Created by Rene Dohan on 12/18/19.
//

import Foundation

public class CSMenuHeader: CSObject {
    private let controller: CSMainController

    var items = [CSMenuItem]()
    let index: Int
    let title: String

    public init(by parent: CSMainController, index: Int, title: String) {
        controller = parent
        self.index = index
        self.title = title
    }

    public func item(with title: String, type: UIBarButtonItem.SystemItem? = nil,
                     image: UIImage? = nil, action: ((CSMenuItem) -> Void)? = nil) -> CSMenuItem
    {
        items.add(CSMenuItem(by: controller, title: title, systemItem: type, image: image, action: action))
            .also { $0.index = items.size - 1 }
    }

    public func item(with view: UIView, action: ((CSMenuItem) -> Void)? = nil) -> CSMenuItem {
        items.add(CSMenuItem(by: controller, view: view, action: action)).also { $0.index = items.size - 1 }
    }

    public var isVisible: Bool {
        for item in items {
            if item.isVisible { return true }
        }
        return false
    }

    public func clear() -> Self {
        items.removeAll()
        return self
    }

    public var isDisplayedAsItem: Bool { title.isEmpty && items.count == 1 && !items.first!.isNoActionItem }
}
