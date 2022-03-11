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
        app/*@START_MENU_TOKEN@*/.staticTexts["Login Later"]/*[[".buttons[\"Login Later\"].staticTexts[\"Login Later\"]",".buttons[\"loginLaterButton\"].staticTexts[\"Login Later\"]",".staticTexts[\"Login Later\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Republique"]/*[[".cells.staticTexts[\"Republique\"]",".staticTexts[\"Republique\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Detect table"].tap()
        app/*@START_MENU_TOKEN@*/.textFields["tableNumberTextField"]/*[[".textFields[\"Table #\"]",".textFields[\"tableNumberTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Select table"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Call a waiter"]/*[[".cells[\"Call a waiter\"].staticTexts[\"Call a waiter\"]",".staticTexts[\"Call a waiter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["The waiter is on his way"].scrollViews.otherElements.buttons["Bring a menu"].tap()
        app.alerts["Got it!"].scrollViews.otherElements.buttons["OK"].tap()
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
