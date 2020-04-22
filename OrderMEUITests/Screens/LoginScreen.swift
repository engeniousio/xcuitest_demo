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
    
    func loginLater() {
        loginLaterButton.tap()
    }
}
