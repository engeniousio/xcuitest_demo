//
//  BaseTest.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 5/13/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }
}
