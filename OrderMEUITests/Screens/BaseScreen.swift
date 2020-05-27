//
//  BaseScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 5/13/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseScreen {
    static let app = XCUIApplication()

    required init() { }

    func tap(_ element: XCUIElement) {
        element.tap()
    }
    
    func type(_ text: String, to element: XCUIElement) {
        element.typeText(text)
    }
}
