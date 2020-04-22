//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantScreen {
    private static let app = XCUIApplication()
    
    private let detectTableOption = app.collectionViews.staticTexts["Detect table"]
    private let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
    
    func detectTable() {
        detectTableOption.tap()
    }
    
    func callAWaiter() {
        callAWaiterOption.tap()
    }
}
