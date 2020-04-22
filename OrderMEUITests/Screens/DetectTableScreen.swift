//
//  DetectTableScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class DetectTableScreen {
    private static let app = XCUIApplication()
    
    private let textField = app.textFields["tableNumberTextField"]
    private let selectButton = app.buttons["Select table"]
    
    func typeNumberOfTable(number: Int) {
        textField.tap()
        textField.typeText(number.description)
    }
    
    func select() {
        selectButton.tap()
    }
    
    
}
