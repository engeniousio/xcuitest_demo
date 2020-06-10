//
//  AppDelegate.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 29.03.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit
import Fabric
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var mainCoordinator: AppCoordinator? = {
        guard let window = window else { return nil }
        var coordinator: AppCoordinator = AppCoordinator.init(window: window)
        return coordinator
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)

        manageInitVC()
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func manageInitVC() {
        mainCoordinator = nil
        window = UIWindow()
        window?.tintColor = Constants.mainThemeColor

        if mainCoordinator == nil {
            guard let window = window else { return }
            mainCoordinator = AppCoordinator(window: window)
        }
        mainCoordinator?.start()
        window?.makeKeyAndVisible()
    }
    
    func clearUserDefaults() {
        let appDomainOpt: String? = Bundle.main.bundleIdentifier
        guard let appDomain = appDomainOpt else { return }
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        let folders: [Any] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let fm = FileManager()
        for path in folders {
            guard let path = path as? String else { continue }
            try? fm.removeItem(atPath: path)
        }
        let folders_document: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fm1 = FileManager()
        for path in folders_document {
            guard let path = path as? String else { continue }
            try? fm1.removeItem(atPath: path)
        }
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

