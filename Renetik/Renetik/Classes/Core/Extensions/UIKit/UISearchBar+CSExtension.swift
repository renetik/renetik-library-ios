//
// Created by Rene Dohan on 2/15/20.
//

import RenetikObjc
import UIKit

public extension UISearchBar {
    var textColor: UIColor? {
        get { textFieldInsideSearchBar?.textColor }
        set(value) { textFieldInsideSearchBar?.textColor = value }
    }

    func transparent() {
        barTintColor = UIColor.clear
        backgroundColor = UIColor.clear
    }

    private var textFieldInsideSearchBar: UITextField? { value(forKey: "searchField") as? UITextField }
}
