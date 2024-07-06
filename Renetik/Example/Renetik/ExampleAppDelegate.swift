//
//  ExampleAppDelegate.swift
//  Renetik
//
//  Created by rene-dohan on 02/19/2019.
//  Copyright (c) 2019 rene-dohan. All rights reserved.
//

import Renetik
import RenetikObjc

@UIApplicationMain
class ExampleAppDelegate: CSAppDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(DDASLLogger.sharedInstance)
        setup(CocoaLumberjackCSLogger(), CSNavigationController())
        window = UIWindow()
        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        Style.didFinishLaunchingWithOptions(self)
        ExampleListController().push()
        logInfo("ExampleAppDelegate didFinishLaunchingWithOptions")
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
