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
    
    override init() {
        super.init()
        visible()
    }
    
    func openRepublique() {
        tap(republiqueRestaurant)
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

