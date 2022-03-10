//
//  AccessibilityIdentifiers.swift
//  orderMe
//
//  Created by Bay-QA on 2/22/18.
//  Copyright © 2018 Bay-QA. All rights reserved.
//

import Foundation

typealias AI = AccessibilityIdentifiers

struct AccessibilityIdentifiers {
    struct LoginScreen {
        static let loginToFacebook = "facebookLoginButton"
        static let loginLaterButton = "loginLaterButton"
    }
    
    struct RestaurantDetailsScreen {
        static let detectTable = "Detect table"
        static let menu = "Menu"
        static let reservation = "Reservation"
        static let callWaiter = "Call a waiter"
    }
    
    struct DishesScreen {
        static let plusButton = "plusButton"
        static let minusButton = "minusButton"
    }
    
    struct BucketScreen {
        static let acceptButton = "acceptButton"
        static let deleteAllButton = "deleteAllButton"
    }
    
    struct TableIDScreen {
        static let tableNumberTextField = "tableNumberTextField"
        static let selectTableButton = "Select table"
    }
    
    struct FacebookSignInScreen {
        static let continueLoginButton = "Continue"
    }
}
