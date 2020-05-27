//
//  LoginScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/15/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import Foundation
import XCTest

class LoginScreen: BaseScreen {
    private let loginLaterButton: XCUIElement = app.buttons["loginLaterButton"]
    
    required init() {
        super.init()
        visible()
    }
    
    func loginLater() -> RestaurantListScreen {
        tap(loginLaterButton)
        return RestaurantListScreen()
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
