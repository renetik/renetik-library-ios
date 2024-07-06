//
//  CSApplicationDelegate.swift
//  BlocksKit
//
//  Created by Rene Dohan on 2/9/19.
//

import RenetikObjc

public let delegate: CSApplicationDelegate = .instance()
public let logger: CSLogger = delegate.logger
public let navigation: CSNavigationController = delegate.navigation

open class CSApplicationDelegate: UIResponder, UIApplicationDelegate {
    public var logger: CSLogger!
    public var navigation: CSNavigationController!
    public var window: UIWindow?

    public func setup(logger: CSLogger, navigation: CSNavigationController) {
        self.logger = logger
        self.navigation = navigation
    }
}

@objc public extension CSApplicationDelegate {
    class func instance() -> Self {
        UIApplication.shared.delegate as! Self
    }
}
