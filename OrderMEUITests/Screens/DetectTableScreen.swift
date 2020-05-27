//
//  DetectTableScreen.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 4/22/20.
//  Copyright © 2020 Boris Gurtovoy. All rights reserved.
//

import XCTest

class DetectTableScreen: BaseScreen {

    private let textField = app.textFields["tableNumberTextField"]
    private let selectButton = app.buttons["Select table"]
    
    required init() {
        super.init()
        visible()
    }

    @discardableResult
    func typeNumberOfTable(number: Int) -> Self {
        tap(textField)
        type(number.description, to: textField)
        return self
    }

    @discardableResult
    func select() -> Self {
        tap(selectButton)
        return self
    }
}

extension DetectTableScreen {
    private func visible() {
        guard textField.waitForExistence(timeout: 5) else {
            XCTFail("Detect Table Screen is not visible")
            return
        }
    }
}

