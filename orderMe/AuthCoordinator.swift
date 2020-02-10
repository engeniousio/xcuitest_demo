//
//  AuthCoordinator.swift
//  orderMe
//
//  Created by Саид A2B on 2/10/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class AuthCoordinator: PCoordinator {
    
    private var window: UIWindow
    
    lazy var tabBarCoordinator: TabBarCoordinator? = .init(window: window)
    private let loginManager: LoginManager = LoginManager()

    init(window: UIWindow) {
        self.window = window
        print(String(describing: self) + " - object CREATED ✨✨✨")
    }
    
    deinit {
        print(String(describing: self) + " - object killed 💥💥💥")
    }
    
    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
                
        self.checkAccessToken(completion: { () -> Void? in
            self.startTabBarCoordinator()
        }) { (error) -> Void? in
            vc.errorAlert(error)
        }
        
        vc.onTapContinueWithFacebook { [weak self] in
            guard let self = self else { return }
            self.loginManager.logOut()
            
            self.loginManager.logIn(permissions: ["email", "public_profile"],
                                    from: vc) { (result, error) in
                switch result {
                case .some:
                    self.loginToServerAfterFacebook(completion: {
                        self.startTabBarCoordinator()
                    }) { (error) in
                        vc.errorAlert(error)
                    }
                case .none:
                    vc.errorAlert(error as NSError?)
                }
            }
        }.onTapLoginLater { [weak self] in
            guard let self = self else { return }
            NetworkClient.analytics(action: .loginLaterTapped)
            self.startTabBarCoordinator()
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func checkAccessToken(completion: @escaping (() -> Void?), errorCompletion: @escaping ((NSError) -> Void?)) {
        AccessToken.refreshCurrentAccessToken { (_, _, _) in
            if AccessToken.current != nil {
                self.loginToServerAfterFacebook(completion: {
                    completion()
                }) { (error) in
                    errorCompletion(error)
                }
            }
        }
    }
    
    fileprivate func loginToServerAfterFacebook(completion: @escaping (() -> Void?), errorCompletion: @escaping ((NSError) -> Void?)) {
        guard let accessToken = AccessToken.current?.tokenString else { return }
        NetworkClient.login(accessToken: accessToken) { (user, error) in
            if let error = error {
                errorCompletion(error)
                return
            }
            SingletonStore.sharedInstance.user = user
            print("APP TOKEN: " + (user?.token ?? "HUUHUH"))
            print("FACEBOOK TOKEN: " + (accessToken))
            completion()
        }
        NetworkClient.analytics(action: .facebookTapped)
    }

    func startTabBarCoordinator() {
        tabBarCoordinator?.start()
    }
    
}
