//
//  CSMainController+Menu.swift
//  Renetik
//
//  Created by Rene Dohan on 3/14/19.
//

import Foundation
import RenetikObjc

public extension CSMainController {
    @discardableResult
    func menu(title: String = "", image: UIImage? = nil,
              type: UIBarButtonItem.SystemItem? = nil,
              onClick: ((CSMenuItem) -> Void)? = nil) -> CSMenuItem
    {
        menuAdd().item(with: title, type: type, image: image, action: onClick)
    }

    @discardableResult
    func menu(title: String = "", image: UIImage? = nil,
              type: UIBarButtonItem.SystemItem? = nil,
              onClick: Func? = nil) -> CSMenuItem
    {
        menuAdd().item(with: title, type: type, image: image, action: { _ in onClick?() })
    }

    @discardableResult
    func menu(view: UIView,
              onClick: ((CSMenuItem) -> Void)? = nil) -> CSMenuItem
    {
        menuAdd().item(with: view, action: onClick)
    }
}
