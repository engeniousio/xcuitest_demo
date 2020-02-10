//
//  LoginViewController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 12/30/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginToFacebook: UIButton!
    @IBOutlet weak var loginLaterButton: UIButton!
    
    private var didTapContinueWithFacebook: (() -> Void)?
    private var didTapLoginLater: (() -> Void)?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginToFacebook.accessibilityIdentifier = AccessibilityIdentifiers.LoginScreen.loginToFacebook
        loginLaterButton.accessibilityIdentifier = AccessibilityIdentifiers.LoginScreen.loginLaterButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loginLaterButton.layer.insertSublayer(view.themeGradient(), at: 0)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func continueWithFacebook() {
        self.didTapContinueWithFacebook?()
    }
    
    @IBAction func logInLaterButton() {
        self.didTapLoginLater?()
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
    
}

// MARK: Actions
extension LoginViewController {
    
    @discardableResult
    func onTapContinueWithFacebook(action: @escaping () -> Void) -> Self {
        didTapContinueWithFacebook = action
        return self
    }

    @discardableResult
    func onTapLoginLater(action: @escaping () -> Void) -> Self {
        didTapLoginLater = action
        return self
    }

}
