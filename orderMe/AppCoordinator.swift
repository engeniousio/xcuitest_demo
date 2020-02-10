//
//  AppCoordinator.swift
//  orderMe
//
//  Created by Саид A2B on 2/10/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import UIKit

class AppCoordinator: PCoordinator {
    
    private var window: UIWindow

    lazy var tabBarCoordinator: TabBarCoordinator? = .init(window: window)
    lazy var authCoordinator: AuthCoordinator? = .init(window: window)

    init(window: UIWindow) {
        self.window = window
        print(String(describing: self) + " - object CREATED ✨✨✨")

    }
    
    func start() {
        if SingletonStore.sharedInstance.user != nil {
            showMain()
        } else {
            showAuth()
        }
    }
        
    deinit {
        print(String(describing: self) + " - object killed 💥💥💥")
    }
    
    func showMain() {
        tabBarCoordinator?.start()
    }
    
    func showAuth() {
        authCoordinator?.start()
    }

}

