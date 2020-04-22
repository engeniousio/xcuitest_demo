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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let app = XCUIApplication()
        app.launch()
        
        let loginScreen = LoginScreen()
        loginScreen.loginLater()

        let restaurant = app.tables.staticTexts["Republique"]
        restaurant.tap()
        
        let detectTableOption = app.collectionViews.staticTexts["Detect table"]
        detectTableOption.tap()
        
        let textField = app.textFields["tableNumberTextField"]
        textField.tap()
        textField.typeText("3")
        
        let selectTableButton = app.buttons["Select table"]
        selectTableButton.tap()
        
        let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
        callAWaiterOption.tap()
        
        let bringAMenu = app.alerts["The waiter is on his way"].scrollViews.otherElements.buttons["Bring a menu"]
        bringAMenu.tap()
        
        sleep(1)
        
        XCTAssertTrue(app.alerts["Got it!"].exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
