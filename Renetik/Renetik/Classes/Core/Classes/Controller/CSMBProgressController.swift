//
// Created by Rene Dohan on 1/11/20.
//

import ChameleonFramework
import Foundation
import MBProgressHUD

public class CSMBProgressController: CSObject, CSHasProgress, CSHasDialogVisible {
    public var backgroundColor = UIColor.flatBlack()!.lighten(byPercentage: 0.03)!.add(alpha: 0.85)
    public var foregroundColor = UIColor.white
    private let view: UIView
    private var hud: MBProgressHUD?

    public init(in controller: UIViewController) {
        view = controller.view
    }

    public init(in view: UIView) {
        self.view = view
    }

    public var isDialogVisible: Bool { hud.notNil }

    public func hideDialog(animated: Bool = true) { hud?.hide(animated: animated) }

    public func show(progress title: String, cancel: CSDialogAction?) -> CSHasDialogVisible {
        MBProgressHUD.hide(for: view, animated: true)
        hud = MBProgressHUD.showAdded(to: view, animated: true).also { hud in
            hud.removeFromSuperViewOnHide = true
            hud.animationType = .zoom
            hud.contentColor = foregroundColor
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = .clear
            hud.backgroundView.style = .solidColor
            hud.backgroundView.backgroundColor = backgroundColor
            cancel.notNil { cancel in
                hud.detailsLabel.text = title.isSet ? "\n" + title + "\n" : "\n"
                hud.button.text(cancel.title ?? .dialogCancel).onClick {
                    cancel.action()
                    hud.hide(animated: true)
                }
            }.elseDo {
                hud.detailsLabel.text = "\n" + title.asString
            }
        }
        return self
    }
}
