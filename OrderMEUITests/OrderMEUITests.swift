//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/15/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: BaseTest {

    func testBringAMenu() {
        let loginScreen = LoginScreen()
        let restaurantListScreen = loginScreen.loginLater()
        let restaurantScreen = restaurantListScreen.openRepublique()
        restaurantScreen.choose(option: .detectTable)
        let detectTableScreen = DetectTableScreen()

        detectTableScreen
            .typeNumberOfTable(number: 3)
            .select()

        restaurantScreen.choose(option: .callAWaiter)
        restaurantScreen.bringAMenu()

        XCTAssertTrue(restaurantScreen.gotItAlert.waitForExistence(timeout: 5))
    }
}
