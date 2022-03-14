//
//  LoginScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/14/22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import Foundation
import XCTest

class LoginScreen{
    
    static let app = XCUIApplication()
    
    private let loginLaterButton: XCUIElement = app.buttons["Login Later"]
    
    func loginLater(){
        loginLaterButton.tap()
    }
    
}
