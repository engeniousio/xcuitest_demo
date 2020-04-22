//
//  RestaurantListScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantListScreen {
    private static let app = XCUIApplication()
    
    private let republiqueRestaurant = app.tables.staticTexts["Republique"]
    
    func openRepublique() {
        republiqueRestaurant.tap()
    }
}
