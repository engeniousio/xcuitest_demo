//
//  LoginViewController.swift
//  orderMe
//
//  Created by Bay-QA on 12/30/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginToFacebook: UIButton!
    @IBOutlet weak var loginLaterButton: UIButton!
    
    var cameFromReserveOrOrderProcess = false
    
    private let loginManager: LoginManager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginToFacebook.accessibilityIdentifier = AccessibilityIdentifiers.LoginScreen.loginToFacebook
        loginLaterButton.accessibilityIdentifier = AccessibilityIdentifiers.LoginScreen.loginLaterButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loginLaterButton.layer.insertSublayer(view.themeGradient(), at: 0)
        
        self.navigationController?.isNavigationBarHidden = true
        AccessToken.refreshCurrentAccessToken { (_, _, _) in
            if AccessToken.current != nil {
                self.loginToServerAfterFacebook()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func continueWithFacebook() {
        self.loginManager.logOut()
        self.loginButtonClicked()
    }
    
    @IBAction func logInLaterButton() {
        self.successLogin()
        NetworkClient.analytics(action: .loginLaterTapped)
    }
    
    fileprivate func loginToServerAfterFacebook() {
        guard let accessToken = AccessToken.current?.tokenString else { return }
        NetworkClient.login(accessToken: accessToken) { (user, error) in
            if let error = error { 
                self.errorAlert(error)
                return
            }
            SingletonStore.sharedInstance.user = user
            self.successLogin()
        }
        NetworkClient.analytics(action: .facebookTapped)
    }
    
    fileprivate func loginButtonClicked() {
        loginManager.logIn(permissions: ["email", "public_profile"],
                           from: self) { (result, error) in
                            if result != nil {
                                self.loginToServerAfterFacebook()
                            } else {
                                self.errorAlert(error as NSError?)
                            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK : results of login
extension LoginViewController {
    func errorAlert(_ error: NSError? = nil) {
        let alertController = UIAlertController(title: "Error", message: "Sorry, some error occured. Try again later. " + (error?.description ?? ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func successLogin() {
        switch cameFromReserveOrOrderProcess {
        case false:
            if let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as? MyTabBarController {
                mainTabBarController.selectedIndex = 1
                mainTabBarController.modalPresentationStyle = .fullScreen
                present(mainTabBarController, animated: false, completion: nil)
            }
        case true:
            self.cameFromReserveOrOrderProcess = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
