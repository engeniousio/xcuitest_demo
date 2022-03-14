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

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let loginScreen = LoginScreen()
        loginScreen.loginLater()
        
        let restaurant = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Republique"]/*[[".cells.staticTexts[\"Republique\"]",".staticTexts[\"Republique\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        restaurant.tap()
        
        let detectTableOption = app.collectionViews.staticTexts["Detect table"]
        detectTableOption.tap()
        
        let textField = app/*@START_MENU_TOKEN@*/.textFields["tableNumberTextField"]/*[[".textFields[\"Table #\"]",".textFields[\"tableNumberTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("3")
        
        let selectTableButton = app.buttons["Select table"]
        selectTableButton.tap()
        
        let callWaiterOption = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Call a waiter"]/*[[".cells[\"Call a waiter\"].staticTexts[\"Call a waiter\"]",".staticTexts[\"Call a waiter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        callWaiterOption.tap()
        
        sleep(1)
        
        let bringMenus = app.alerts["The waiter is on his way"].scrollViews.otherElements.buttons["Bring a menu"]
        bringMenus.tap()
        
        sleep(1)
        
        XCTAssert(app.alerts["Got it!"].exists)
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
