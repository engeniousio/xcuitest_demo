//
//  RestaurantListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/14/22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantListScreen {
    private static let app = XCUIApplication()
    
    private let republiqueRestaurant = app.tables.staticTexts["Republique"]
    
    func openRepublique() {
        republiqueRestaurant.tap()
    }
}
