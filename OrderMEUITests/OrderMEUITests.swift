//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/11/22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBringAMenu() throws {
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
        
        sleep(1)
                
        let bringAMenu = app.alerts["The waiter is on his way"].scrollViews.otherElements.buttons["Bring a menu"]
        bringAMenu.tap()
                
        sleep(1)
                
        XCTAssertTrue(app.alerts["Got it!"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
