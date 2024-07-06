//
// Created by Rene Dohan on 12/18/19.
//

import BlocksKit
import Renetik

public extension UIBarButtonItem {
    class var flexSpaceItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }

    class var fixedSpaceItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    }

    class func space(_ width: CGFloat = 15) -> UIBarButtonItem { fixedSpaceItem.width(width) }

    func width(_ value: CGFloat) -> Self { invoke { width = value } }

    convenience init(image: UIImage, onClick: ((_ sender: UIBarButtonItem) -> Void)? = nil) {
        self.init()
        if let action = onClick {
            bk_init(with: image, style: UIBarButtonItem.Style.plain, handler: { action($0 as! UIBarButtonItem) })
        } else {
            self.init(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
    }

//    convenience init(image: UIImage, title: String, onClick: ((_ sender: UIBarButtonItem) -> Void)? = nil){
//        let button = UIButton() // TODO ??
//        button.setImage(image, for: .normal)
//        button.setTitle(title, for: .normal)
//        button.sizeToFit()
//        return UIBarButtonItem(customView: button)
//        if let action = onClick {
//            bk_init(with: image, style: UIBarButtonItem.Style.plain, handler: { action($0 as! UIBarButtonItem) })
//        }
//    }

    convenience init(item: UIBarButtonItem.SystemItem, onClick: ((_ sender: UIBarButtonItem) -> Void)? = nil) {
        self.init()
        if let action = onClick {
            bk_init(with: item, handler: { action($0 as! UIBarButtonItem) })
        } else {
            self.init(barButtonSystemItem: item, target: nil, action: nil)
        }
    }

    convenience init(title: String, onClick: ((_ sender: UIBarButtonItem) -> Void)? = nil) {
        self.init()
        if let action = onClick {
            bk_init(withTitle: title, style: UIBarButtonItem.Style.plain,
                    handler: { action($0 as! UIBarButtonItem) })
        } else {
            self.init(title: title, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
    }
}
