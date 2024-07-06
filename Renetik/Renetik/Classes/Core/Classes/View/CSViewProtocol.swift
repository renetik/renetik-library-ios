////
//// Created by Rene Dohan on 12/25/19.
////
//
// import Foundation
// import UIKit
// import RenetikObjc
//
// public protocol CSViewProtocol where Self: UIView {
//    func show<Data>(progress response: CSResponse<Data>,
//                    title: String, canCancel: Bool) -> CSResponse<Data>
//
//    func show(progress title: String, canCancel: Bool) -> MBProgressHUD
//
//    func show(title: String, message: String, positiveTitle: String,
//              onPositive: @escaping Function, canCancel: Bool) -> MBProgressHUD
// }
//
// public extension CSViewProtocol {
//    public func show<Data>(progress response: CSResponse<Data>) -> CSResponse<Data> {
//        show(progress: response, title: "", canCancel: true)
//    }
//
//    public func show(progress title: String) -> MBProgressHUD {
//        show(progress: title, canCancel: true)
//    }
//
//    public func show(title: String, message: String,
//                     positiveTitle: String,
//                     onPositive: @escaping Function) -> MBProgressHUD {
//        show(title: title, message: message, positiveTitle: positiveTitle, onPositive: onPositive, canCancel: true)
//    }
// }
