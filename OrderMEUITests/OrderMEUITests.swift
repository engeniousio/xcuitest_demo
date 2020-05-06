//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/15/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testBringAMenu() {
        let app = XCUIApplication()
        app.launch()
        
        let loginScreen = LoginScreen()
        loginScreen.loginLater()

        let restaurantListScreen = RestaurantListScreen()
        restaurantListScreen.openRepublique()
        
        let restaurantScreen = RestaurantScreen()
        restaurantScreen.detectTable()
        
        let detectTableScreen = DetectTableScreen()
        detectTableScreen.typeNumberOfTable(number: 3)
        detectTableScreen.select()

        restaurantScreen.callAWaiter()
        restaurantScreen.bringAMenu()

        XCTAssertTrue(restaurantScreen.gotItAlert.waitForExistence(timeout: 5))
    }
}
