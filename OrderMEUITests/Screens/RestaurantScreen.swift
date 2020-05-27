//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

enum RestaurantOption {
    case detectTable
    case menu
    case reservation
    case callAWaiter
}

class RestaurantScreen: BaseScreen {

    private let detectTableOption = app.collectionViews.staticTexts["Detect table"]
    private let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
    private let bringAMenuButton = app.alerts["The waiter is on his way"].buttons["Bring a menu"]
    let gotItAlert = app.alerts["Got it!"]

    required init() {
        super.init()
        visible()
    }
    
    func choose(option: RestaurantOption) {
        switch option {
        case .detectTable:
            tap(detectTableOption)
        case .menu:
            break
        case .reservation:
            break
        case .callAWaiter:
            tap(callAWaiterOption)
        }
    }

    func bringAMenu() {
        tap(bringAMenuButton)
    }
}

extension RestaurantScreen {
    private func visible() {
        guard detectTableOption.waitForExistence(timeout: 5) else {
            XCTFail("Restaurant Screen is not visible")
            return
        }
    }
}
