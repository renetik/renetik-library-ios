//
// Created by Rene Dohan on 12/2/19.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import ChameleonFramework
import UIKit

public class CSAlertDialogController: CSObject, CSHasDialog, CSHasDialogVisible, CSHasSheet {
    private let controller: UIViewController
    private var alert: UIAlertController?

    public init(in controller: UIViewController) {
        self.controller = controller
    }

    public var isDialogVisible: Bool { alert.notNil }

    public func hideDialog(animated: Bool) { alert?.dismiss(animated: animated) }

    public func show(title: String?, message: String?, actions: [CSDialogAction]?, positive: CSDialogAction?,
                     cancel: CSDialogAction?, from element: CSDisplayElement) -> CSHasDialogVisible
    {
        hideDialog(animated: false)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions?.forEach { action in alert.add(action: action, style: .default) }
        positive.notNil { action in alert.add(action: action, style: .destructive, preferred: true) }
        cancel.notNil { action in alert.add(action: action, style: .cancel) }
        self.alert = alert.present(from: element)
        return self
    }

    public func show(title: String?, message: String, positive: CSDialogAction?,
                     negative: CSDialogAction?, cancel: CSDialogAction?) -> CSHasDialogVisible
    {
        hideDialog(animated: false)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        negative.notNil { action in alert.add(action: action, style: .destructive) }
        positive.notNil { action in alert.add(action: action, style: .default, preferred: true) }
        if cancel?.title != nil { alert.add(action: cancel!, style: .cancel) }
        self.alert = alert.present()
        return self
    }
}

public extension UIAlertController {
    func add(action: CSDialogAction, style: UIAlertAction.Style, preferred: Bool = false) -> UIAlertAction {
        UIAlertAction(title: action.title, style: style) { _ in action.action() }.also {
            addAction($0)
            if preferred { preferredAction = $0 }
        }
    }
}
