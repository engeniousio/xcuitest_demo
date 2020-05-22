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
        loginScreen.loginLater()

        let restaurantListScreen = RestaurantListScreen()
        restaurantListScreen.openRepublique()
        
        let restaurantScreen = RestaurantScreen()
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
