//
// Created by Rene Dohan on 12/26/19.
//

import Foundation

public protocol CSValueGetProtocol {
    associatedtype CSValueType
    var value: CSValueType { get }
}

public protocol CSValueProtocol: CSValueGetProtocol {
    associatedtype CSValueType
    var value: CSValueType { get set }
}
