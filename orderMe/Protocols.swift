//
//  MyCellProtocol.swift
//  iOrder
//
//  Created by Bay-QA on 06.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import Foundation

// MARK: to synchronize the state of Bucket on multiple viewcontrollers
protocol BucketCellProtocolAddDelete {
    func addDish(_ dish: Dish)
    func deleteDish(_ dish: Dish)
}

// MARK: to alert the information about dish
protocol InfoDishProtocol {
    func showInfoDish(_ dish: Dish)
}

// MARK: to ask confirmation for deleting reservation
protocol RepeatQuestionProtocol {
    func confirmationAlert(_ reserve: Reserve)
}

// MARK:  to add new reservation
protocol NewReservationProtocol {
    func addNewReservation(reserve: Reserve)
}

// MARK:  to add new order
protocol NewOrderProtocol {
    func addNewOrder(order: Order)
}

protocol AccessibilityEnabling {
    func setupAccessibilityLabels()
}

// MARK: returns true when program runs on simulator and false when on the real device
struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
