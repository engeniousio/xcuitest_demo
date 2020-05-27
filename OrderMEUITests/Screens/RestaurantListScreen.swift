//
//  RestaurantListScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantListScreen: BaseScreen {

    private let republiqueRestaurant = app.tables.staticTexts["Republique"]

    required init() {
        super.init()
        visible()
    }

    func openRepublique() -> RestaurantScreen {
        tap(republiqueRestaurant)
        return RestaurantScreen()
    }
}

extension RestaurantListScreen {
    private func visible() {
        guard republiqueRestaurant.waitForExistence(timeout: 5) else {
            XCTFail("Restaurant List Screen is not visible")
            return
        }
    }
}
