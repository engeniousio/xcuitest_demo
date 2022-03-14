//
//  DetectTableScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/14/22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import Foundation

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
