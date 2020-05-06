//
//  LoginScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/15/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import Foundation
import XCTest

class LoginScreen {
    
    private static let app = XCUIApplication()
    
    private let loginLaterButton: XCUIElement = app.buttons["loginLaterButton"]
    
    init() {
        visible()
    }
    
    func loginLater() {
        loginLaterButton.tap()
    }
}

extension LoginScreen {
    private func visible() {
        guard loginLaterButton.waitForExistence(timeout: 5) else {
            XCTFail("Login Screen is not visible")
            return
        }
    }
}
