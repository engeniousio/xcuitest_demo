//
//  AppDelegate.swift
//  iOrder
//
//  Created by Bay-QA on 29.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)
        
        self.window?.tintColor = Constants.mainThemeColor

        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {

        let isFBURL = ((url.scheme?.hasPrefix("fb\(Settings.appID ?? "")"))! && url.host == "authorize")
        if  isFBURL == true {
            let options: [UIApplication.OpenURLOptionsKey: Any] = [
                .sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication]!,
                .annotation: options[UIApplication.OpenURLOptionsKey.annotation]!
            ]
            return ApplicationDelegate.shared.application(application,
                                                          open: url,
                                                          options: options)
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }

}
