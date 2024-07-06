//
// Created by Rene Dohan on 2/7/20.
//

import Foundation
import MBProgressHUD
import RenetikObjc
import UIKit

public class CSMBDialogController: NSObject, CSHasDialog, CSHasDialogVisible, MBProgressHUDDelegate {
    public var backgroundColor = UIColor.flatBlack()!.lighten(byPercentage: 0.03)!.add(alpha: 0.7)
    public var foregroundColor = UIColor.white
    private var hud: MBProgressHUD!
    private let view: UIView

    public init(in view: UIView) {
        self.view = view
    }

    public func show(title: String?, message: String, positive: CSDialogAction?, negative: CSDialogAction?,
                     cancel: CSDialogAction?) -> CSHasDialogVisible
    {
        MBProgressHUD.hide(for: view, animated: true)
        hud = MBProgressHUD.showAdded(to: view, animated: true).also { hud in
            hud.mode = .text
            hud.removeFromSuperViewOnHide = true
            hud.animationType = .zoom
            hud.contentColor = foregroundColor
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = backgroundColor
            hud.backgroundView.style = .solidColor
            hud.backgroundView.backgroundColor = .clear
            hud.label.text = title
            hud.detailsLabel.text = "\n" + message + "\n\n"
            positive.notNil { action in
                hud.button.text(action.title ?? CSStrings.dialogYes).onClick {
                    action.action()
                    hud.hide(animated: true)
                }
            }
            negative.notNil { _ in
                fatalError("Negative not implemented")
            }
            cancel.notNil { action in
                hud.onClick {
                    hud.hide(animated: true)
                    action.action()
                }
            }
            hud.delegate = self
        }
        return self
    }

    public var isDialogVisible: Bool { hud.notNil }

    public func hideDialog(animated: Bool = true) { hud?.hide(animated: animated) }

    public func hudWasHidden(_ _: MBProgressHUD) {
        hud = nil
    }
}
