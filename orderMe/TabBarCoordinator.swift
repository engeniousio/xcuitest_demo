//
//  TabBarCoordinator.swift
//  orderMe
//
//  Created by Саид A2B on 2/10/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import UIKit

class TabBarCoordinator: PCoordinator {
        
    private var window: UIWindow
    
    let tabController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? MyTabBarController {
            self.tabController = tabController
            self.tabController.selectedIndex = 1
            self.tabController.modalPresentationStyle = .fullScreen
            
            window.rootViewController = tabController
        } else {
            self.tabController = UITabBarController()
        }

        print(String(describing: self) + " - object CREATED ✨✨✨")
    }
     
    deinit {
        print(String(describing: self) + " - object killed 💥💥💥")
    }

    func start() {}
    
}

